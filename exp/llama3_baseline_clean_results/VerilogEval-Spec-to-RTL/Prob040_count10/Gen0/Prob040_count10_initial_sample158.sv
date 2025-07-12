module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 4'b0000; // Initialize count to 0

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // Reset count to 0 when reset is high
    end else if (count == 4'd9) begin
        count <= 4'b0000; // Reset count to 0 when it reaches 10
    end else begin
        count <= count + 1; // Increment count by 1
    end
end

assign q = count; // Assign count to output q

endmodule