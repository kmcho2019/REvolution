module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state_reg;
    
    // Shift register control signals
    wire shift_en = (state_reg == 3'b000 & x) |  // S0->S1
                    (state_reg == 3'b001 & x) |  // S1->S4
                    (state_reg == 3'b010 & x) |  // S2->S1
                    (state_reg == 3'b011 & x) |  // S3->S2
                    (state_reg == 3'b100 & ~x);  // S4->S3
    
    wire load_en = ~shift_en;
    wire [2:0] load_data = 
        (state_reg == 3'b000 & ~x) ? 3'b000 :  // S0->S0
        (state_reg == 3'b001 & ~x) ? 3'b001 :  // S1->S1
        (state_reg == 3'b010 & ~x) ? 3'b010 :  // S2->S2
        (state_reg == 3'b011 & ~x) ? 3'b001 :  // S3->S1
        (state_reg == 3'b100 & x)  ? 3'b100 :  // S4->S4
        3'b000;  // default
    
    // Shift register implementation
    always @(posedge clk) begin
        if (reset)
            state_reg <= 3'b000;
        else if (shift_en)
            state_reg <= {state_reg[1:0], 1'b0};  // Right shift with 0 fill
        else if (load_en)
            state_reg <= load_data;
    end
    
    // Output is high in states S3 (011) and S4 (100)
    assign z = (state_reg == 3'b011) | (state_reg == 3'b100);

endmodule