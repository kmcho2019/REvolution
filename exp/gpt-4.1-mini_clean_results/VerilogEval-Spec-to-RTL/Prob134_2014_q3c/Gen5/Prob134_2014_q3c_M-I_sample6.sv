module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,    // Present state input
    output       Y0,
    output       z
);

    reg [2:0] state_reg;    // Registered present state
    reg [2:0] next_state;

    // Register the input present state y to reduce glitches
    always @(posedge clk) begin
        state_reg <= y;
    end

    // Compute next state combinationally based on registered present state and input x
    always @(*) begin
        case (state_reg)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Output z depends on current registered state (state_reg)
    // z=1 for states 3'b011 and 3'b100, else 0
    assign z = ((state_reg == 3'b011) || (state_reg == 3'b100)) ? 1'b1 : 1'b0;

    // Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule