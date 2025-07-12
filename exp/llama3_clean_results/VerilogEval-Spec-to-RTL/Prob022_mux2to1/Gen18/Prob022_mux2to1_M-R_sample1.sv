// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output reg out  // Output
);

// Implement a 2-to-1 multiplexer using always block and if-else
always @(*) begin
    if (sel) begin
        out = b;
    end else begin
        out = a;
    end
end

endmodule