module TopModule(input a, input b, output out);
    wire mux0_out, mux1_out;

    // First MUX selects between 0 and b based on 'a'
    assign mux0_out = a ? b : 1'b0;
    // Second MUX selects between mux0_out and 0 based on 'b'
    // (Though redundant logically, added for demonstration)
    assign mux1_out = b ? mux0_out : 1'b0;

    assign out = mux1_out;
endmodule