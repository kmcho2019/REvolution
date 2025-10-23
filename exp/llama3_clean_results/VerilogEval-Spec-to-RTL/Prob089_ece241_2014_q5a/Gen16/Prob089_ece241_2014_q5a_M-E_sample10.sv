module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg; // Assuming an 8-bit input for demonstration
reg [7:0] inverted;
reg [7:0] result;
reg carry;
reg [2:0] state; // 0: Reset, 1: Input, 2: Output
reg [2:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 8'b0;
        inverted <= 8'b0;
        result <= 8'b0;
        carry <= 1'b0;
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: begin // Reset state
                if (!areset) begin
                    state <= 3'b001; // Transition to input state
                end
            end
            3'b001: begin // Input state
                shift_reg <= {shift_reg[6:0], x}; // Shift in the input bit
                if (areset) begin
                    state <= 3'b000; // Reset
                end else begin
                    state <= 3'b001; // Stay in input state
                end
            end
            3'b010: begin // Output state
                inverted <= ~shift_reg; // Invert the bits
                result <= inverted + 1; // Add 1 to get 2's complement
                z <= result[0]; // Output the least significant bit
                state <= 3'b010; // Stay in output state
            end
            default: state <= 3'b000;
        endcase
    end
end

always @(*) begin
    case (state)
        3'b001: next_state = 3'b010; // Transition to output state after input
        default: next_state = state;
    endcase
end

endmodule