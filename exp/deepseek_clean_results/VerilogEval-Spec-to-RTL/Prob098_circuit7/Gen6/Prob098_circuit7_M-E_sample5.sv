module TopModule (
    input clk,
    input a,
    output reg q
);

// State definition
localparam STATE_Q1 = 1'b1;
localparam STATE_Q0 = 1'b0;

reg state;

initial begin
    state = STATE_Q1; // Initial state
    q = 1'bx; // Unknown until first clock
end

always @(posedge clk) begin
    case (state)
        STATE_Q1: begin
            q <= 1'b1;
            if (a) state <= STATE_Q0;
        end
        STATE_Q0: begin
            q <= 1'b0;
            // No state change - terminal state
        end
    endcase
end

endmodule