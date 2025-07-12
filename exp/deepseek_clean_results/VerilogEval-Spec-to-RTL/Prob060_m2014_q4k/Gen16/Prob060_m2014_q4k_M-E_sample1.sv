module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire circular_feedback;
    
    // Circular feedback from MSB to LSB
    assign circular_feedback = shift_reg[3];
    
    // Output is always the MSB
    assign out = shift_reg[3];
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            // Standard shift operation with external input
            shift_reg <= {shift_reg[2:0], in};
            
            // Alternative circular shift implementation (commented out)
            // shift_reg <= {shift_reg[2:0], circular_feedback};
        end
    end

endmodule