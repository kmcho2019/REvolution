module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State encoding
localparam [2:0] STATE_A = 3'b000;
localparam [2:0] STATE_B = 3'b001;
localparam [2:0] STATE_C = 3'b010;
localparam [2:0] STATE_D = 3'b011;
localparam [2:0] STATE_E = 3'b100;
localparam [2:0] STATE_F = 3'b101;

reg [2:0] state; // 3-bit state register

// State transition logic
always @ (posedge clk) begin
    if (reset) begin
        state <= STATE_A; // Reset to state A
    end else begin
        case (state)
            STATE_A: state <= w ? STATE_B : STATE_A; // State A
            STATE_B: state <= w ? STATE_C : STATE_D; // State B
            STATE_C: state <= w ? STATE_E : STATE_D; // State C
            STATE_D: state <= w ? STATE_F : STATE_A; // State D
            STATE_E: state <= w ? STATE_E : STATE_D; // State E
            STATE_F: state <= w ? STATE_C : STATE_D; // State F
            default: state <= STATE_A; // Default to state A
        endcase
    end
end

// Output z
assign z = (state == STATE_E || state == STATE_F); // z is high when state is E or F

endmodule