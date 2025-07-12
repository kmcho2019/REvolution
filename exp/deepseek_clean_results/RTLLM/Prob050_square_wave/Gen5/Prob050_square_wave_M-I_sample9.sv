module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    reg [7:0] gray_count;
    wire [7:0] next_gray = (gray_count >> 1) ^ (count - 1);

    always @(posedge clk) begin
        if (count == 0) begin
            wave_out <= ~wave_out;
            count <= freq;
            gray_count <= {1'b0, freq[7:1]} ^ freq; // Binary to gray conversion
        end else begin
            count <= count - 1;
            gray_count <= next_gray;
        end
    end

endmodule