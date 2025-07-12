module TopModule (
    input  in1,
    input  in2,
    output reg out
);

always @(*) begin
    // Explicitly defining the combinational logic for clarity and synthesis optimization
    out = ~(in1 | in2);
end

endmodule