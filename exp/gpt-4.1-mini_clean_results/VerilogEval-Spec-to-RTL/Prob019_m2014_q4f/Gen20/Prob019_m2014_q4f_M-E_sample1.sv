module TopModule (
    input  wire in1,
    input  wire in2,
    output reg  out
);
    reg not_in2;

    always @* begin
        not_in2 = ~in2;   // invert in2 explicitly
        out = in1 & not_in2; // AND with in1
    end
endmodule