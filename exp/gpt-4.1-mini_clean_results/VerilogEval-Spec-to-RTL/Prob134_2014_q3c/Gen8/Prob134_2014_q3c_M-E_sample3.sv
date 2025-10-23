module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] state;
    reg [2:0] next_state;

    // Synchronous state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Combinational next state logic and output logic
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Output z combinationally from current state
    assign z = (state == 3'b011) || (state == 3'b100);

    // Output Y0 from next state's LSB (computed combinationally)
    assign Y0 = next_state[0];

    // Optional: initial state loading from y on first clock after reset
    // If reset is needed, can add async reset and load y there
    // For now, the initial value of state is unknown - synthesis tools may add reset
    
endmodule