module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case (state)
        3'b000: next_state = (w) ? 3'b001 : 3'b000; // A
        3'b001: next_state = (w) ? 3'b010 : 3'b011; // B
        3'b010: next_state = (w) ? 3'b100 : 3'b011; // C
        3'b011: next_state = (w) ? 3'b101 : 3'b000; // D
        3'b100: next_state = (w) ? 3'b100 : 3'b011; // E
        3'b101: next_state = (w) ? 3'b010 : 3'b011; // F
        default: next_state = 3'b000; // default to A
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // reset to A
    end else begin
        state <= next_state;
    end
end

assign z = (state == 3'b100) || (state == 3'b101);

endmodule