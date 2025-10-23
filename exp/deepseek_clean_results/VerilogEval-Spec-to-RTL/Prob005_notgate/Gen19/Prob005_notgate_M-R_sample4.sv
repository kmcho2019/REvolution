module TopModule (
    input in,
    output out
);
    // Explicit 2:1 MUX implementation of NOT gate
    wire mux_out;
    wire [1:0] mux_inputs = {1'b0, 1'b1};  // Inputs to MUX: [0] = 0, [1] = 1
    
    assign mux_out = mux_inputs[in];
    assign out = mux_out;
endmodule