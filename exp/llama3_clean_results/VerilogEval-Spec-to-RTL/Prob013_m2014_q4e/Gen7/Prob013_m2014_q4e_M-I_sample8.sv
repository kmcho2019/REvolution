module TopModule (
    input  in1,
    input  in2,
    output reg out
);

// Using a synthesis-friendly coding style to define the NOR gate
always @(*) begin
    out = ~(in1 | in2); // Directly implements a NOR gate
end

endmodule