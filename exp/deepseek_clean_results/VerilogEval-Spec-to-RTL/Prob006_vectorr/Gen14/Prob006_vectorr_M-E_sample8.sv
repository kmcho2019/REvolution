module TopModule (
    input [7:0] in,
    output reg [7:0] out
);

    // Internal shift register
    reg [7:0] shift_reg;
    
    // Control signal (could be external in real implementation)
    wire load = 1'b1;  // Always load for this simple implementation
    
    always @(*) begin
        if (load) begin
            // Parallel load with bit reversal
            shift_reg[0] <= in[7];
            shift_reg[1] <= in[6];
            shift_reg[2] <= in[5];
            shift_reg[3] <= in[4];
            shift_reg[4] <= in[3];
            shift_reg[5] <= in[2];
            shift_reg[6] <= in[1];
            shift_reg[7] <= in[0];
            
            // Output the reversed bits immediately
            out <= shift_reg;
        end
    end

    /* Alternative sequential implementation with clock
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= {in[0], in[1], in[2], in[3],
                         in[4], in[5], in[6], in[7]};
        end else begin
            shift_reg <= shift_reg << 1;  // Could shift out bits serially
        end
        out <= shift_reg;
    end
    */

endmodule