module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

// Internal binary counter
reg [9:0] bin_count;

// Gray code conversion
wire [9:0] gray_count;
assign gray_count = bin_count ^ (bin_count >> 1);

// Assign output (Gray coded)
assign q = gray_count;

// Hierarchical counter implementation
always @(posedge clk) begin
    if (reset) begin
        bin_count <= 10'b0;
    end
    else begin
        if (&bin_count[9:7] & &bin_count[6:4] & (bin_count[3:0] == 4'd9)) begin
            bin_count <= 10'b0;
        end
        else begin
            bin_count <= bin_count + 1'b1;
        end
    end
end

endmodule