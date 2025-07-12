module TopModule(
    input  in1,
    input  in2,
    output out
);

// Implement the NOR gate using a combinational always block
always @(*) begin
    out = ~(in1 | in2);
end

endmodule