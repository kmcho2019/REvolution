module TopModule(
    input  a,
    input  b,
    output reg q
);

    // Using a combinational always block for flexibility
    always @(*) begin
        q = a & b; // Perform the AND operation
    end

endmodule