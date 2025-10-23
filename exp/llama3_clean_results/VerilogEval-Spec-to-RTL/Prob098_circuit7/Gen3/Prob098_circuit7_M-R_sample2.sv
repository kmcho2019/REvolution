module TopModule (
    input clk,
    input a,
    output reg q
);

// Initialize q to avoid undefined state
initial q = 1;

always @(posedge clk) begin
    // Simplified conditional statement
    q <= a ? 0 : 1;
end

endmodule