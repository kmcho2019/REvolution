module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state; // Current state
reg [2:0] next_state; // Next state

// Determine next state based on current state and input 'w'
always @(*)
begin
    case (state)
        3'b000: next_state = (w)? 3'b000 : 3'b001; // A
        3'b001: next_state = (w)? 3'b011 : 3'b010; // B
        3'b010: next_state = (w)? 3'b011 : 3'b100; // C
        3'b011: next_state = (w)? 3'b000 : 3'b101; // D
        3'b100: next_state = (w)? 3'b011 : 3'b100; // E
        3'b101: next_state = (w)? 3'b011 : 3'b010; // F
        default: next_state = 3'b000; // Default state
    endcase
end

// Update state on positive edge of clock
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state; // Update state
    end
end

// Determine output 'z' based on current state
always @(*)
begin
    case (state)
        3'b000, 3'b001, 3'b010, 3'b011: z = 0; // States A, B, C, D
        3'b100, 3'b101: z = 1; // States E, F
        default: z = 0; // Default output
    endcase
end

endmodule