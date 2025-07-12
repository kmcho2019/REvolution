module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z
);

    always @(A or B) begin
        z = (A == B);
    end

endmodule