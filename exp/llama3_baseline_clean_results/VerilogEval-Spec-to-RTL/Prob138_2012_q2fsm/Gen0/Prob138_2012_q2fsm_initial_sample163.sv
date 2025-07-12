module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State encoding: A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101

always @(*) begin
    case(current_state)
        3'b000: next_state = (w)? 3'b001 : 3'b000; // A
        3'b001: next_state = (w)? 3'b010 : 3'b011; // B
        3'b010: next_state = (w)? 3'b100 : 3'b011; // C
        3'b011: next_state = (w)? 3'b101 : 3'b000; // D
        3'b100: next_state = (w)? 3'b100 : 3'b011; // E
        3'b101: next_state = (w)? 3'b010 : 3'b011; // F
        default: next_state = 3'b000; // Default to state A
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

assign z = ((current_state == 3'b100) && (w == 1)) || ((current_state == 3'b101) && (w == 1));

endmodule