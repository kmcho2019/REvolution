module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    wire xor_xy;

    // Compute XOR first
    assign xor_xy = x ^ y;

    // Use always block for final assignment
    always @(*) begin
        z = xor_xy & x;
    end
endmodule