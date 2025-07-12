module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out   <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
            out <= state;
        end
    end
endmodule