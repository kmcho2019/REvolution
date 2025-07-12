module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    // Pattern '01' represents state A (output 0)
    // Pattern '11' represents state B (output 1)
    reg [1:0] state_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 2'b11;  // Initialize to state B
        end else begin
            case (state_reg)
                2'b01: state_reg <= in ? 2'b01 : 2'b11;  // A transitions
                2'b11: state_reg <= in ? 2'b11 : 2'b01;  // B transitions
                default: state_reg <= 2'b11;              // Fault recovery
            endcase
        end
    end
    
    // Output is MSB of shift register
    assign out = state_reg[1];
    
endmodule