module square_wave (
    input        clk,
    input        rst,        // Active-high synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one;
    wire enable;

    assign enable = (freq != 8'd0);
    assign freq_minus_one = freq - 8'd1;

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (enable) begin
            if (count == freq_minus_one) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= 8'd0;
            // wave_out holds state implicitly
        end
    end

endmodule