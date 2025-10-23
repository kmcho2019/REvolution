module TopModule (
    input wire a,
    input wire b,
    output reg out
);
    always @(*) begin
        out = ~(a ^ b); // Implement XNOR using combinational always block
    end
endmodule