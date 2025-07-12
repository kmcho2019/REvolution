module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire mux_out;
    reg q_out;
    
    // 2:1 mux implemented with continuous assignment
    assign mux_out = L ? r_in : q_in;
    
    // Flip-flop with explicit mux input
    always @(posedge clk) begin
        q_out <= mux_out;
    end
    
    assign Q = q_out;

endmodule