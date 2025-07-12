module TopModule(
    input           clk,      // clock signal
    input           reset,    // reset signal (active high)
    output [9:0]     q        // 10-bit output
);

reg [9:0] count; // 10-bit register to hold the count value

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0; // reset to 0 when reset is high
    end else if (count == 10'd999) begin
        count <= 10'd0; // reset to 0 when count reaches 999
    end else begin
        count <= count + 10'd1; // increment count on each clock cycle
    end
end

assign q = count; // assign the count value to the output

endmodule