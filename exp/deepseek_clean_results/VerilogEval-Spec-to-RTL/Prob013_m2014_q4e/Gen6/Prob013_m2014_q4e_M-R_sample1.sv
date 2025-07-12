module TopModule (
    input  in1,
    input  in2,
    output reg out
);
    always @(*) begin
        out = ~(in1 | in2);  // NOR operation using procedural assignment
    end
endmodule