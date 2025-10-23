module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Declare a packed register array for the shift register
    reg [3:0] shift_reg;
    
    // Output assignment from the last flip-flop
    assign out = shift_reg[3];
    
    // Shift register implementation using concatenation
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], in};
        end
    end

endmodule