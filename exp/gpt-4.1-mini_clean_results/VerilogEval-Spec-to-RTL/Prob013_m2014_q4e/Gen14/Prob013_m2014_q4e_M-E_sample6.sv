module TopModule (
    input  in1,
    input  in2,
    output out
);
    reg nor_result;
    wire out_wire;

    // Compute NOR function in an always_comb procedural block
    always @* begin
        nor_result = ~(in1 | in2);
    end

    // Assign the result of procedural logic to an output wire
    assign out_wire = nor_result;

    // Connect internal wire to output port
    assign out = out_wire;

endmodule