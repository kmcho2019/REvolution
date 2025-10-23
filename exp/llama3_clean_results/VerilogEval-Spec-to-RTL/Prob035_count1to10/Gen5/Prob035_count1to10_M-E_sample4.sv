module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] bin_count;
reg [3:0] dec_out;

always @(posedge clk) begin
    if (reset) begin
        bin_count <= 4'b0001; // Reset to 1
    end else if (bin_count == 4'd10) begin
        bin_count <= 4'b0001; // Wrap around from 10 to 1
    end else begin
        bin_count <= bin_count + 1; // Increment count
    end
end

always @(*) begin
    case (bin_count)
        4'b0000: dec_out = 4'b0001; // 0 -> 1
        4'b0001: dec_out = 4'b0001; // 1 -> 1
        4'b0010: dec_out = 4'b0010; // 2 -> 2
        4'b0011: dec_out = 4'b0011; // 3 -> 3
        4'b0100: dec_out = 4'b0100; // 4 -> 4
        4'b0101: dec_out = 4'b0101; // 5 -> 5
        4'b0110: dec_out = 4'b0110; // 6 -> 6
        4'b0111: dec_out = 4'b0111; // 7 -> 7
        4'b1000: dec_out = 4'b1000; // 8 -> 8
        4'b1001: dec_out = 4'b1001; // 9 -> 9
        4'b1010: dec_out = 4'b1010; // 10 -> 10
        default: dec_out = 4'b0001; // Invalid -> 1
    endcase
end

assign q = dec_out;

endmodule