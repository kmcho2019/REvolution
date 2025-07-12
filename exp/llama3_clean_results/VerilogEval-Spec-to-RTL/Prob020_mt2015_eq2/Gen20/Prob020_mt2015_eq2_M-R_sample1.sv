module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);
always @(*)
begin
    if (A == B)
        z = 1'b1;
    else
        z = 1'b0;
    // Alternatively, this can be simplified to:
    // z = (A == B)? 1'b1 : 1'b0;
end
endmodule