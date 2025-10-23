module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q_out = 1'b0;  // Explicit initialization to 0
    
    always @(posedge clk) begin
        q_out <= L ? r_in : q_in;
    end
    
    assign Q = q_out;

endmodule