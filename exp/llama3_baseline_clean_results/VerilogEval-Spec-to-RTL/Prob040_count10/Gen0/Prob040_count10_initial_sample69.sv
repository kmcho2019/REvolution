module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @ (posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // Reset to 0 when reset is high
    end else if (count == 4'b1001) begin // Check if count has reached 9
        count <= 4'b0000; // Reset to 0
    end else begin
        count <= count + 1; // Increment count
    end
end

assign q = count;

endmodule