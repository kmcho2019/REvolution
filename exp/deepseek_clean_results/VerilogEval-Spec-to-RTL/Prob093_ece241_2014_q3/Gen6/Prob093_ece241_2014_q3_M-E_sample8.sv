module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_c, not_d;
    
    // Compute ~c using mux (select 1 when c=0, else 0)
    assign not_c = c ? 1'b0 : 1'b1;
    
    // Compute ~d using mux (select 1 when d=0, else 0)
    assign not_d = d ? 1'b0 : 1'b1;
    
    // mux_in[0] = c & ~d
    wire c_and_not_d;
    assign c_and_not_d = c ? not_d : 1'b0;
    
    // mux_in[1] = ~c & ~d
    wire not_c_and_not_d;
    assign not_c_and_not_d = not_c ? not_d : 1'b0;
    
    // mux_in[2] = ~c | (c & d)
    wire c_and_d;
    assign c_and_d = c ? d : 1'b0;
    wire mux_in_2;
    assign mux_in_2 = not_c ? 1'b1 : c_and_d;
    
    // mux_in[3] = ~c | d
    wire mux_in_3;
    assign mux_in_3 = not_c ? 1'b1 : d;
    
    assign mux_in = {mux_in_3, not_c_and_not_d, mux_in_2, c_and_not_d};

endmodule