module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q_reg;
    
    always @(posedge clk) begin
        q_reg <= L ? r_in : q_in;
    end
    
    assign Q = q_reg;

endmodule