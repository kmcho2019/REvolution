module TopModule(
    input clk,
    input d,
    output reg q = 0 // Initialize q directly in the port declaration
);

// Utilize a single always block for sequential logic
always @(posedge clk) begin
    // Directly assign the value of 'd' to 'q' at the positive edge of 'clk'
    q = d;
end

endmodule