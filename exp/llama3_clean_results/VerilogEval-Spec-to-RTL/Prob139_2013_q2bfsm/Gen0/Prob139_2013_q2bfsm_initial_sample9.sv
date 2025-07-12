module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Current state and next state
state_t current_state, next_state;

// Temporary variables for tracking x sequence and y timeout
logic [1:0] x_count;
logic [1:0] y_count;

// Combinational logic to determine next state
always_comb begin
    next_state = current_state;
    case (current_state)
        A: if (~resetn) begin
            next_state = A;
        end else begin
            next_state = B;
        end
        B: next_state = C;
        C: if (x_count == 2'b111) begin
            next_state = D;
            x_count = 0;
        end else begin
            case (x)
                1'b1: x_count = {x_count[0], 1'b1};
                1'b0: x_count = {x_count[0], 1'b0};
            endcase
        end
        D: if (y) begin
            next_state = E;
        end else if (y_count == 2) begin
            next_state = F;
        end else begin
            y_count = y_count + 1;
        end
        E, F: next_state = current_state;
    endcase
end

// Sequential logic to update state and outputs
always_ff @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            B: f <= 1'b1;
            default: f <= 1'b0;
        endcase
        case (current_state)
            D, E: g <= 1'b1;
            default: g <= 1'b0;
        endcase
        case (current_state)
            C: case (x)
                1'b1: x_count <= {x_count[0], 1'b1};
                1'b0: x_count <= {x_count[0], 1'b0};
            endcase
            D: if (~y) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 0;
            end
            default: begin
                x_count <= 0;
                y_count <= 0;
            end
        endcase
    end
end

endmodule