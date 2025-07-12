module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state; // state variable to store the current state
reg [2:0] next_state; // next state variable

// assign output z based on the current state
always @(*) begin
    case (state)
        3'b000: z = 0; // A
        3'b001: z = 0; // B
        3'b010: z = 0; // C
        3'b011: z = 0; // D
        3'b100: z = 1; // E
        3'b101: z = 1; // F
        default: z = 0;
    endcase
end

// determine next state based on current state and input w
always @(*) begin
    case (state)
        3'b000: next_state = (w == 1'b1) ? 3'b000 : 3'b001; // A
        3'b001: next_state = (w == 1'b1) ? 3'b011 : 3'b010; // B
        3'b010: next_state = (w == 1'b1) ? 3'b011 : 3'b100; // C
        3'b011: next_state = (w == 1'b1) ? 3'b000 : 3'b101; // D
        3'b100: next_state = (w == 1'b1) ? 3'b011 : 3'b100; // E
        3'b101: next_state = (w == 1'b1) ? 3'b011 : 3'b010; // F
        default: next_state = 3'b000; // default to A
    endcase
end

// update state on positive edge of clock and reset when reset is high
always @(posedge clk, posedge reset) begin
    if (reset) begin
        state <= 3'b000; // reset state to A
    end else begin
        state <= next_state; // update state to next state
    end
end

endmodule