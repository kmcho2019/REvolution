module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    wire pattern_match;
    
    // Shift register implementation using explicit wiring
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end
    
    // Combinational pattern matching
    assign pattern_match = (shift_reg == 4'b1101);
    
    // Persistent output using a simple latch
    reg start_shifting_reg;
    always @(posedge clk) begin
        if (reset) begin
            start_shifting_reg <= 1'b0;
        end else if (pattern_match) begin
            start_shifting_reg <= 1'b1;
        end
    end
    
    assign start_shifting = start_shifting_reg;

endmodule