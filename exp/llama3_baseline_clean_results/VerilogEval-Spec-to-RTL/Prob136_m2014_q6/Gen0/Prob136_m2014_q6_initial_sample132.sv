module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Output logic
always @(current_state) begin
    case (current_state)
        3'b100: z = 1'b1;  // State E
        3'b101: z = 1'b1;  // State F
        default: z = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (current_state)
        3'b000: next_state = (w == 1'b1) ? 3'b000 : 3'b001;  // State A
        3'b001: next_state = (w == 1'b1) ? 3'b011 : 3'b010;  // State B
        3'b010: next_state = (w == 1'b1) ? 3'b011 : 3'b100;  // State C
        3'b011: next_state = (w == 1'b1) ? 3'b000 : 3'b101;  // State D
        3'b100: next_state = (w == 1'b1) ? 3'b011 : 3'b100;  // State E
        3'b101: next_state = (w == 1'b1) ? 3'b011 : 3'b010;  // State F
        default: next_state = 3'b000;
    endcase
end

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 3'b000;
    end else begin
        current_state <= next_state;
    end
end

endmodule