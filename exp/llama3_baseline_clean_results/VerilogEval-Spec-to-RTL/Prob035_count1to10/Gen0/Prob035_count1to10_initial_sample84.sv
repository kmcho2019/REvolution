module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1 when reset is high
    end else if (count == 4'd10) begin
        count <= 4'd1; // Reset count to 1 when it reaches 10
    end else begin
        count <= count + 1; // Increment count otherwise
    end
end

assign q = count; // Assign the current count to output q

endmodule