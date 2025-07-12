module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] idx; // 3-bit index for positions 0 to 7

    // State update: increment idx modulo 8 on clock, reset to 0
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            idx <= 3'd0;
        end else begin
            idx <= idx + 3'd1;
        end
    end

    // Output is a one-hot vector with bit 'idx' set
    assign out = 8'b0000_0001 << idx;

endmodule