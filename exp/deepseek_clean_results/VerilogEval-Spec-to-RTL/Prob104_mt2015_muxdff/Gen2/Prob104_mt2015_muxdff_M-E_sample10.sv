module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q_out;
    wire gated_clk;
    wire clock_enable;
    
    // Clock gating logic - only enable clock when needed
    assign clock_enable = L || (q_in != q_out);
    assign gated_clk = clk & clock_enable;
    
    // Main flip-flop with gated clock
    always @(posedge gated_clk) begin
        q_out <= L ? r_in : q_in;
    end
    
    assign Q = q_out;

endmodule