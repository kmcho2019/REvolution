module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output reg   z
);

// Combinational logic block that sets z to 1 if A equals B, else 0.
always @(*) begin
    if (A == B)
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule