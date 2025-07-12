module TopModule(
    input clk,
    input a,
    output reg q = 1 // Initialize q to 1
);

reg a_ever_high = 1'b0; // Flag to indicate if 'a' has ever been high

always @(posedge clk) begin
    if (!a_ever_high && a) // If 'a' is high and has not been high before
        a_ever_high <= 1'b1; // Set the flag
    q <= !a_ever_high; // 'q' is high if 'a' has never been high
end

endmodule