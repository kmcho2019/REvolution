module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State definitions
localparam [2:0] STATE_A = 3'b000;
localparam [2:0] STATE_B = 3'b001;
localparam [2:0] STATE_C = 3'b010;
localparam [2:0] STATE_D = 3'b011;
localparam [2:0] STATE_E = 3'b100;
localparam [2:0] STATE_F = 3'b101;

reg [2:0] current_state; // Current state
reg [2:0] next_state;    // Next state

// State transitions
always @(*) begin
    case (current_state)
        STATE_A: next_state = w ? STATE_B : STATE_A;
        STATE_B: next_state = w ? STATE_C : STATE_D;
        STATE_C: next_state = w ? STATE_E : STATE_D;
        STATE_D: next_state = w ? STATE_F : STATE_A;
        STATE_E: next_state = w ? STATE_E : STATE_D;
        STATE_F: next_state = w ? STATE_C : STATE_D;
        default: next_state = STATE_A;
    endcase
end

// State register
always @ (posedge clk) begin
    if (reset) begin
        current_state <= STATE_A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign z = (current_state == STATE_E) || (current_state == STATE_F);

endmodule