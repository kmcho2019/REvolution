module GenericGate #(
    parameter int NUM_INPUTS = 2,
    parameter string OPERATION = "AND"
)(
    input [NUM_INPUTS-1:0] inputs,
    output out_assign,
    output reg out_alwaysblock
);

assign out_assign = (OPERATION == "AND") ? &inputs : (OPERATION == "OR") ? |inputs : 1'b0;

always @(*) begin
    case (OPERATION)
        "AND": out_alwaysblock = &inputs;
        "OR": out_alwaysblock = |inputs;
        default: out_alwaysblock = 1'b0;
    endcase
end

endmodule

module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

wire [1:0] inputs;
assign inputs[0] = a;
assign inputs[1] = b;

GenericGate #(.NUM_INPUTS(2), .OPERATION("AND")) u_generic_gate(
    .inputs(inputs),
    .out_assign(out_assign),
    .out_alwaysblock(out_alwaysblock)
);

endmodule