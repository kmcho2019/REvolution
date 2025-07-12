module TopModule (
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

// Next state logic
always @(*) begin
    case (state)
        3'b000: // A
            next_state = w? 3'b001 : 3'b000;
        3'b001: // B
            next_state = w? 3'b010 : 3'b011;
        3'b010: // C
            next_state = w? 3'b100 : 3'b011;
        3'b011: // D
            next_state = w? 3'b101 : 3'b000;
        3'b100: // E
            next_state = w? 3'b100 : 3'b011;
        3'b101: // F
            next_state = w? 3'b010 : 3'b011;
        default:
            next_state = 3'b000; // Default to state A
    endcase
end

// Output logic
assign z = (state == 3'b100 || state == 3'b101);

endmodule