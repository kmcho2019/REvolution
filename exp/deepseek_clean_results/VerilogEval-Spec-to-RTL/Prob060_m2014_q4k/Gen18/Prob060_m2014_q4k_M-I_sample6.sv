module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Enable signal for potential clock gating (commented out as not in original spec)
    // input enable;
    // wire gated_clk = enable ? clk : 1'b0;
    // wire actual_clk = gated_clk;  // Would use this if implementing clock gating
    
    reg [3:0] shift_reg;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], in};
        end
    end
    
    assign out = shift_reg[3];

    /* Alternative with clock gating (would require enable input):
    always @(posedge actual_clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], in};
        end
    end
    */
endmodule