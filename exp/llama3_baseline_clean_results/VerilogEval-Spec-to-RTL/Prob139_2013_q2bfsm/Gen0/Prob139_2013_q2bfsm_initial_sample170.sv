module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states
typedef enum logic [2:0] {
    A,
    B,
    C,
    D,
    E,
    F
} state_t;

state_t current_state;
state_t next_state;
logic [1:0] x_sequence;
logic [1:0] y_counter;

// Initialize the outputs
assign f = (current_state == B) ? 1'b1 : 1'b0;
assign g = (current_state == E) ? 1'b1 : (current_state == F) ? 1'b0 : (current_state == D) ? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        x_sequence <= (current_state == C) ? {x, x_sequence[0]} : x_sequence;
        y_counter <= (current_state == D) ? (y ? 0 : y_counter + 1) : 0;
    end
end

// Combinational logic
always_comb begin
    next_state = current_state;
    case (current_state)
        A: begin
            if (resetn) begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x_sequence == 3'b101) begin
                next_state = D;
            end
        end
        D: begin
            if (y || (y_counter == 2)) begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = F;
                end
            end
        end
        E, F: begin
            // Stay in the same state
        end
        default: begin
            next_state = A;
        end
    endcase
end

endmodule