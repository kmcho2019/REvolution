// TopModule: A decade counter that counts from 0 to 9 and then resets back to 0.
//            It has an active high synchronous reset.

module TopModule (
    input  clk,  // Clock input
    input  reset, // Active high synchronous reset
    output [3:0] q  // 4-bit output representing the count
);

// Internal register to store the count
reg [3:0] count;

// Always block triggered on the positive edge of the clock
always @ (posedge clk) begin
    // If reset is high, reset the counter to 0
    if (reset) begin
        count <= 4'b0000;
    // If the count has reached 9 (1001 in binary), reset it back to 0
    end else if (count == 4'd9) begin
        count <= 4'b0000;
    // Otherwise, increment the count
    end else begin
        count <= count + 1'b1;
    end
end

// Assign the count to the output
assign q = count;

endmodule