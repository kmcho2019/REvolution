module TopModule (
    output reg one,
    input clk,
    input rst_n
);
    // Single-state FSM that always outputs 1
    localparam S_ONE = 1'b0;
    
    reg state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_ONE;
            one <= 1'b0;  // Reset value (overridden below)
        end
        else begin
            case (state)
                S_ONE: one <= 1'b1;  // Permanent output
                default: one <= 1'b1; // Catch-all
            endcase
        end
    end
endmodule