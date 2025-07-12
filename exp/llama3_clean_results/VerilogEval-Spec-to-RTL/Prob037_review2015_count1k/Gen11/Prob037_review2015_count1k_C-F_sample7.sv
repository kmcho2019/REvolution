// TopModule: A 10-bit counter that counts from 0 to 999 with a period of 1000 cycles.
module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output [9:0] q // 10-bit output
);

// Declare a 10-bit register to hold the count
reg [9:0] count;

// Always block to handle the clock edge and reset
always @(posedge clk) begin
    // If reset is high, reset the counter to 0
    if (reset) begin
        count <= 10'd0;
    // If the count reaches 999, reset it to 0
    end else if (count == 10'd999) begin
        count <= 10'd0;
    // Otherwise, increment the counter
    end else begin
        count <= count + 10'd1;
    end
end

// Assign the count to the output
assign q = count;

endmodule