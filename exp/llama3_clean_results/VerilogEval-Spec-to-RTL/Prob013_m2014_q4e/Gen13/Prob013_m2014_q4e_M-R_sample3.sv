module TopModule(
    input  in1,
    input  in2,
    output reg out
);
// Implementation of a 2-input NOR gate within a combinational always block
always @(*) begin
    out = ~(in1 | in2);
end
endmodule