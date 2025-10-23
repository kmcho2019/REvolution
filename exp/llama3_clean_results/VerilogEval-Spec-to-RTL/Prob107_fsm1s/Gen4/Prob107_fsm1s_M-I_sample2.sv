module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Parameterized state type
parameter STATE_B = 1'b1, STATE_A = 1'b0;
reg [0:0] state, next_state;

// State Register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= STATE_B;
        out <= 1'b1;
    end else begin
        state <= next_state;
    end
end

// Next State Logic and Output Logic
always_comb begin
    case (state)
        STATE_B: begin
            next_state = in? STATE_B : STATE_A;
            out = 1'b1;
        end
        STATE_A: begin
            next_state = in? STATE_A : STATE_B;
            out = 1'b0;
        end
    endcase
end

endmodule