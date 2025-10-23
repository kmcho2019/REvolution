module TopModule(
    input           clk,
    input   [7:0]   in,
    output  [7:0]   pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector

always @ (posedge clk) begin
    prev_in <= in; // Update the previous state at each clock cycle
end

assign pedge = in & (~prev_in); // Set output bit to 1 if current bit is 1 and previous bit is 0

endmodule