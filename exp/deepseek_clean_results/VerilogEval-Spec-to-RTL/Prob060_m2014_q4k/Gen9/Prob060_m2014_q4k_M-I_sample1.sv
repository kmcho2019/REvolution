module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire gated_clk;
    reg last_in;
    wire enable;
    
    // Detect input changes to enable shifting
    assign enable = (in != last_in);
    
    // Clock gating
    assign gated_clk = clk & enable;
    
    always @(posedge gated_clk or negedge resetn) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            last_in <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], in};
            last_in <= in;
        end
    end
    
    assign out = shift_reg[3];

endmodule