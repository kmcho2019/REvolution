module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // Reset to 1
    end else begin
        if (count == 4'b1010) begin // If count is 10, wrap around to 1
            count <= 4'b0001;
        end else begin
            count <= count + 1; // Increment count
        end
    end
end

assign q = count;

endmodule