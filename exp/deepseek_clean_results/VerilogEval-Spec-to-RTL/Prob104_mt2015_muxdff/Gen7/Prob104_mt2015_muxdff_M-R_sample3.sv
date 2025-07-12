module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q;
    wire mux_out;
    
    // 2:1 Mux implemented with continuous assignment
    assign mux_out = L ? r_in : q_in;
    
    // D Flip-flop
    always @(posedge clk) begin
        q <= mux_out;
    end
    
    assign Q = q;

endmodule