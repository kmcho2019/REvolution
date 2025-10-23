module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q;
    wire mux_out;
    
    assign mux_out = L ? r_in : q_in;
    
    always @(posedge clk) begin
        q <= mux_out;
    end
    
    assign Q = q;

endmodule