module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Generate one-hot enables for sel [0..8]
    wire sel_valid = (sel < 4'd9);

    wire [8:0] en = 9'b0;
    wire [8:0] en_decoded;

    assign en_decoded = (sel_valid) ? (9'b1 << sel) : 9'b0;

    // Gate each input vector with its corresponding enable
    wire [15:0] gated_inputs [8:0];
    assign gated_inputs[0] = {16{en_decoded[0]}} & a;
    assign gated_inputs[1] = {16{en_decoded[1]}} & b;
    assign gated_inputs[2] = {16{en_decoded[2]}} & c;
    assign gated_inputs[3] = {16{en_decoded[3]}} & d;
    assign gated_inputs[4] = {16{en_decoded[4]}} & e;
    assign gated_inputs[5] = {16{en_decoded[5]}} & f;
    assign gated_inputs[6] = {16{en_decoded[6]}} & g;
    assign gated_inputs[7] = {16{en_decoded[7]}} & h;
    assign gated_inputs[8] = {16{en_decoded[8]}} & i;

    // OR all gated inputs to produce output when valid
    wire [15:0] mux_out = gated_inputs[0] | gated_inputs[1] | gated_inputs[2] | 
                          gated_inputs[3] | gated_inputs[4] | gated_inputs[5] | 
                          gated_inputs[6] | gated_inputs[7] | gated_inputs[8];

    // Output all ones if sel invalid, else mux_out
    assign out = sel_valid ? mux_out : 16'hFFFF;

endmodule