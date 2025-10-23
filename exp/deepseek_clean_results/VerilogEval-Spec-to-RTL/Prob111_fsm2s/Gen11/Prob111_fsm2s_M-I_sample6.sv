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
    reg prev_j, prev_k;
    wire clk_enable;
    
    // Detect input changes for clock gating
    assign clk_enable = (j != prev_j) || (k != prev_k) || reset;
    
    always @(posedge clk) begin
        prev_j <= j;
        prev_k <= k;
        
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else if (clk_enable) begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
            out <= state;
        end
    end

endmodule