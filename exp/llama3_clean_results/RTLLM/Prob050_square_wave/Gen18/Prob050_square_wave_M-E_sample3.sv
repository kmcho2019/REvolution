module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] bin_count;

always @(posedge clk) begin
    if (bin_count == freq) begin
        bin_count <= 8'd0;
        wave_out <= ~wave_out;
    end else if (bin_count < freq) begin
        if (freq[7] == 1'b1) begin
            bin_count <= bin_count + 8'd128;
        end else if (freq[6] == 1'b1) begin
            bin_count <= bin_count + 8'd64;
        end else if (freq[5] == 1'b1) begin
            bin_count <= bin_count + 8'd32;
        end else if (freq[4] == 1'b1) begin
            bin_count <= bin_count + 8'd16;
        end else if (freq[3] == 1'b1) begin
            bin_count <= bin_count + 8'd8;
        end else if (freq[2] == 1'b1) begin
            bin_count <= bin_count + 8'd4;
        end else if (freq[1] == 1'b1) begin
            bin_count <= bin_count + 8'd2;
        end else if (freq[0] == 1'b1) begin
            bin_count <= bin_count + 8'd1;
        end
    end
end

endmodule