module TopModule(
    input  in1,
    input  in2,
    output reg out
);
    // Refactored implementation of the NOR gate using an always block
    always @(*) begin
        out = ~(in1 | in2);
    end
endmodule