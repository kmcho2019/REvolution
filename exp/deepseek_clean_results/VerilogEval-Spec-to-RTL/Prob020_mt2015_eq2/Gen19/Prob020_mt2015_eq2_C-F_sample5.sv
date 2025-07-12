module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z
);
    always @(*) begin
        // Direct comparison with early termination potential
        z = (A == B);
    end
endmodule