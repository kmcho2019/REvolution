module TopModule (
    input clk,
    input L,
    input d_in,     // Data input (from feedback or load)
    input r_in,     // Load value input
    output Q
);

    reg q;
    
    always @(posedge clk) begin
        q <= L ? r_in : d_in;
    end
    
    assign Q = q;

endmodule