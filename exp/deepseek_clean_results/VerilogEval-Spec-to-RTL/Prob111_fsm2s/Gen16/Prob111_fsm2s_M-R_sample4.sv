module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end
        else begin
            case (state)
                OFF: begin
                    state <= j ? ON : OFF;
                    out <= 1'b0;
                end
                ON: begin
                    state <= k ? OFF : ON;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule