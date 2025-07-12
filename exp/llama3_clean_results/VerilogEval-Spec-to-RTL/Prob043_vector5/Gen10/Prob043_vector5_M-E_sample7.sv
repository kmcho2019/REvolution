module TopModule #(
    parameter NUM_INPUTS = 5,
    parameter NUM_COMPARISONS = NUM_INPUTS * NUM_INPUTS
)(
    input  [NUM_INPUTS-1:0] inputs,
    output [NUM_COMPARISONS-1:0] out
);

    reg [NUM_INPUTS-1:0] row;
    reg [NUM_INPUTS-1:0] col;
    integer i, j;

    always @(*) begin
        for (i = 0; i < NUM_INPUTS; i++) begin
            row = inputs;
            for (j = 0; j < NUM_INPUTS; j++) begin
                out[(i * NUM_INPUTS) + j] = ~(row[i] ^ inputs[j]);
            end
        end
    end

endmodule

module TopModule_wrapper(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    TopModule #(.NUM_INPUTS(5),.NUM_COMPARISONS(25)) top_module (
       .inputs(inputs),
       .out(out)
    );

endmodule