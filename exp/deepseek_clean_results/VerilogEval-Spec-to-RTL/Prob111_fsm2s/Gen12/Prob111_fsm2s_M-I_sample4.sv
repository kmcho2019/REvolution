module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg state;
    reg j_prev, k_prev;
    wire clk_enable;

    // Clock gating control - enable only when inputs change
    assign clk_enable = (j != j_prev) || (k != k_prev) || reset;

    always @(posedge clk) begin
        j_prev <= j;
        k_prev <= k;
        
        if (clk_enable) begin
            if (reset) begin
                state <= OFF;
                out <= 1'b0;
            end else case (state)
                OFF: begin
                    state <= j ? ON : OFF;
                    out <= j ? 1'b1 : 1'b0;
                end
                ON: begin
                    state <= k ? OFF : ON;
                    out <= k ? 1'b0 : 1'b1;
                end
            endcase
        end
    end

endmodule