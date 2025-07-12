module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;  // Initialize state to A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        3'b000:  // State A
            if (w) begin
                next_state = 3'b000;  // Stay in A if w = 1
            end else begin
                next_state = 3'b001;  // Go to B if w = 0
            end
        3'b001:  // State B
            if (w) begin
                next_state = 3'b011;  // Go to D if w = 1
            end else begin
                next_state = 3'b010;  // Go to C if w = 0
            end
        3'b010:  // State C
            if (w) begin
                next_state = 3'b011;  // Go to D if w = 1
            end else begin
                next_state = 3'b100;  // Go to E if w = 0
            end
        3'b011:  // State D
            if (w) begin
                next_state = 3'b000;  // Go to A if w = 1
            end else begin
                next_state = 3'b101;  // Go to F if w = 0
            end
        3'b100:  // State E
            if (w) begin
                next_state = 3'b011;  // Go to D if w = 1
            end else begin
                next_state = 3'b100;  // Stay in E if w = 0
            end
        3'b101:  // State F
            if (w) begin
                next_state = 3'b011;  // Go to D if w = 1
            end else begin
                next_state = 3'b010;  // Go to C if w = 0
            end
        default: next_state = 3'b000;  // Default to state A
    endcase
end

assign z = (state == 3'b100) || (state == 3'b101);  // Output z = 1 if state is E or F

endmodule