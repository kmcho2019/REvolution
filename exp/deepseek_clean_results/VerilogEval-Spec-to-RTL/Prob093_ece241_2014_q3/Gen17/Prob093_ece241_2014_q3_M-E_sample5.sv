module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] implementation
    wire mux0_stage1;
    assign mux0_stage1 = d ? 1'b1 : ~c;
    
    // mux_in[3] implementation
    wire mux3_stage1;
    assign mux3_stage1 = d ? c : 1'b1;
    
    // Final assignments
    assign mux_in[0] = mux0_stage1;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = mux3_stage1;

endmodule