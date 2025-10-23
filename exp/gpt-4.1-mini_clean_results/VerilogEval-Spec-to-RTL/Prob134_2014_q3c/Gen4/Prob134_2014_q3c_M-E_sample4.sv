module TopModule (
    input         clk,
    input         x,
    input   [2:0] y,
    output  reg   Y0,
    output  reg   z
);

    // Internal registers for state and next state
    reg [2:0] state_reg;       // Present state register
    reg [2:0] next_state;      // Next state combinational

    // Synchronize external input y asynchronously loaded into state_reg
    // Here, on every clock edge, the state_reg loads input y (as async override).
    // This assumes y can asynchronously preset the FSM state.
    // If y does not change, it just re-loads the same state.
    always @(posedge clk) begin
        state_reg <= y;
    end

    // Combinational logic for next state based on registered present state and input x
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

    // Register outputs synchronously at clock edge to reduce glitches
    always @(posedge clk) begin
        // z output depends on current state (state_reg)
        z  <= (state_reg == 3'b011) || (state_reg == 3'b100);
        // Y0 output is LSB of next state (computed combinationally)
        Y0 <= next_state[0];
    end

endmodule