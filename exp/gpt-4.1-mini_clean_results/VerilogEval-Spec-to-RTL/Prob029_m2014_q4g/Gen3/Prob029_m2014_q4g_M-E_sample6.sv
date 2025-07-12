module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output reg out
);
    always @(*) begin
        // XNOR can be represented by equality operator
        out <= (in1 == in2) ^ in3;
    end
endmodule