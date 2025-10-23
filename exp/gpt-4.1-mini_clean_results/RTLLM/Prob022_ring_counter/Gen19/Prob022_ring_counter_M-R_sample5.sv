module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] state;

    // State update: increment modulo 8, reset to 0
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 3'd0;
        else
            state <= state + 3'd1; // wraps naturally since state is 3 bits
    end

    // One-hot output: 1 shifted left by state
    assign out = 8'b0000_0001 << state;

endmodule