module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg [1:0] shift_count;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            shift_count <= 2'b0;
        end
        else begin
            // Circular shift operation
            shift_reg <= {shift_reg[2:0], in};
            shift_count <= shift_count + 1;
        end
    end
    
    // Output is always the last bit (same as linear shift register)
    assign out = shift_reg[3];

endmodule