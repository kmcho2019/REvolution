module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

parameter NUM_INPUTS = 3;
parameter NUM_OUTPUTS = 4;

wire [NUM_INPUTS-1:0] inputs;
wire [NUM_OUTPUTS-1:0] outputs;

assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = c;

assign w = outputs[0];
assign x = outputs[1];
assign y = outputs[2];
assign z = outputs[3];

genvar i;
generate
    for (i = 0; i < NUM_INPUTS; i = i + 1) begin
        if (i == 0) begin
            assign outputs[0] = inputs[i];
        end else if (i == 1) begin
            assign outputs[1] = inputs[i];
            assign outputs[2] = inputs[i];
        end else if (i == 2) begin
            assign outputs[3] = inputs[i];
        end
    end
endgenerate

endmodule