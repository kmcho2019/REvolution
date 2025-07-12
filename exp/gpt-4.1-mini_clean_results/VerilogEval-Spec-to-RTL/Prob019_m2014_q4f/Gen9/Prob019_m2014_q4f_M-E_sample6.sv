module TopModule (
    input  in1,
    input  in2,
    output reg out
);
    reg inv_in2;

    always @* begin
        inv_in2 = ~in2;
        out = in1 & inv_in2;
    end

endmodule