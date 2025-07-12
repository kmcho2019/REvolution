module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    // 01 = state A, 10 = state B
    reg [1:0] state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10;  // Reset to state B
        end else begin
            case (state)
                2'b01: state <= in ? 2'b01 : 2'b10;  // A transitions
                2'b10: state <= in ? 2'b10 : 2'b01;  // B transitions
                default: state <= 2'b10;             // Handle invalid states
            endcase
        end
    end
    
    // Output is MSB (1 for B, 0 for A)
    assign out = state[1];
    
endmodule