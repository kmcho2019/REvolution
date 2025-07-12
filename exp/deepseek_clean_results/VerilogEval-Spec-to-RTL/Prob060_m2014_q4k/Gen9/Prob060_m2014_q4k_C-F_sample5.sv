module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // 4-stage shift register with explicit structure
    reg [3:0] shift_reg;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            // Efficient shift operation with direct assignment
            shift_reg <= {shift_reg[2:0], in};
        end
    end
    
    // Direct output connection for best timing
    assign out = shift_reg[3];

endmodule