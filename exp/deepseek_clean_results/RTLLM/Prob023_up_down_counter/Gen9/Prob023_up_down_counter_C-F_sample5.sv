module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion
wire [15:0] bin_count;
reg [15:0] gray_count;

// Binary counter with Gray code output
always @(posedge clk) begin
    if (reset) begin
        bin_count <= 16'b0;
        gray_count <= 16'b0;
    end else begin
        if (up_down) begin
            bin_count <= bin_count + 1'b1;
        end else begin
            bin_count <= bin_count - 1'b1;
        end
        // Convert to Gray code
        gray_count <= bin_count ^ (bin_count >> 1);
    end
end

assign count = gray_count;

endmodule