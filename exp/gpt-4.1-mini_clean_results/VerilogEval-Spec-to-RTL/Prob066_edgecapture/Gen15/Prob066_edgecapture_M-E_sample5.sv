module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // 2-bit shift register per bit to track input transitions:
    // bit 1 = previous input, bit 0 = current input
    reg [1:0] in_hist [31:0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            for (i = 0; i < 32; i = i + 1) begin
                in_hist[i] <= 2'b00;
            end
        end else begin
            for (i = 0; i < 32; i = i + 1) begin
                // Shift in current input bit
                in_hist[i] <= {in_hist[i][0], in[i]};
                // Detect falling edge: previous=1 (in_hist[i][1]) and current=0 (in_hist[i][0])
                if (in_hist[i] == 2'b10)
                    out[i] <= 1'b1;
            end
        end
    end

endmodule