module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current state
state_t current_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (!in) current_state <= A;
                else current_state <= B;
            end
            B: begin
                if (!in) current_state <= C;
                else current_state <= B;
            end
            C: begin
                if (!in) current_state <= A;
                else current_state <= D;
            end
            D: begin
                if (!in) current_state <= C;
                else current_state <= B;
            end
            default: begin
                current_state <= A;
            end
        endcase
    end
end

// Combinational logic for output
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule