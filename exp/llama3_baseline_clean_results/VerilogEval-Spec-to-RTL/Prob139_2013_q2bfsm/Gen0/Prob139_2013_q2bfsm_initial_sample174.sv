module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {
    A = 3'b000,  // Initial state
    B = 3'b001,  // Set output f to 1
    C = 3'b010,  // Monitor x for sequence 1, 0, 1
    D = 3'b011,  // Monitor y, set g to 1
    E = 3'b100   // Decide based on y
} state, next_state;

reg [1:0] x_count;  // Counter for sequence 1, 0, 1
reg [1:0] y_count;  // Counter for y = 1 within 2 cycles
reg [2:0] x_prev;   // Previous values of x

// Next state logic
always_comb begin
    next_state = state;
    case(state)
        A: begin
            if (~resetn) next_state = A;
            else next_state = B;
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x_prev == 3'b101) next_state = D;
        end
        D: begin
            if (y_count == 2'b00 && y) next_state = E;
            else if (y_count == 2'b10) next_state = E;
        end
        E: begin
            // Stay in E
        end
        default: next_state = A;
    endcase
end

// Output logic
always_comb begin
    f = 0;
    g = 0;
    case(state)
        B: f = 1;
        D: g = 1;
        E: g = (y_count == 2'b00 && y) ? 1 : (y_count == 2'b10) ? 0 : g;
        default: ;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_count <= 0;
        y_count <= 0;
        x_prev <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case(state)
            C: begin
                x_prev <= {x_prev[1:0], x};
                if (x_prev[1:0] == 2'b10) x_count <= x_count + 1;
                else x_count <= 0;
            end
            D: begin
                if (y) y_count <= 2'b00;
                else y_count <= y_count + 1;
            end
            default: ;
        endcase
    end
end

endmodule