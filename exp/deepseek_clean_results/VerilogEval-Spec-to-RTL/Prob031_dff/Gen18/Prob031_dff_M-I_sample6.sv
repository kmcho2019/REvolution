`default_nettype none

module TopModule(
    input wire clk,
    input wire reset_n,  // Added synchronous reset
    input wire d,
    output wire q
);
    reg q_reg;
    
    always @(posedge clk) begin
        if (!reset_n) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= d;
        end
    end
    
    assign q = q_reg;
endmodule

`default_nettype wire