module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // Shift register implementation (2 bits)
    reg [1:0] state_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b01;  // Initialize to OFF state
        end else begin
            case (state_reg)
                2'b01: state_reg <= j ? 2'b10 : 2'b01;  // OFF -> ON if j=1
                2'b10: state_reg <= k ? 2'b01 : 2'b10;  // ON -> OFF if k=1
                default: state_reg <= 2'b01;            // Handle any invalid states
            endcase
        end
    end

    // Output is MSB of shift register
    assign out = state_reg[1];

endmodule