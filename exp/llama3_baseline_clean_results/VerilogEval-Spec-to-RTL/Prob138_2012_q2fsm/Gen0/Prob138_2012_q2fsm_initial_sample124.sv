module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        3'b000: // State A
            next_state = (w)? 3'b001 : 3'b000;
        3'b001: // State B
            next_state = (w)? 3'b010 : 3'b011;
        3'b010: // State C
            next_state = (w)? 3'b100 : 3'b011;
        3'b011: // State D
            next_state = (w)? 3'b101 : 3'b000;
        3'b100: // State E
            next_state = (w)? 3'b100 : 3'b011;
        3'b101: // State F
            next_state = (w)? 3'b010 : 3'b011;
        default:
            next_state = 3'b000; // Default state
    endcase
end

// FSM output
assign z = (state == 3'b100) || (state == 3'b101);

endmodule