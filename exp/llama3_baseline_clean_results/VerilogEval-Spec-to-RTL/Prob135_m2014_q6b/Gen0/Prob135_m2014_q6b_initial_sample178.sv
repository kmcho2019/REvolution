module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

always @(*) begin
    case (y)
        3'b000: // State A
            if (~w) begin
                y[1] = 0; // Stay in A
            end else begin
                y[1] = 0; // Stay in A
            end
        3'b001: // State B
            if (~w) begin
                y[1] = 0; // Transition to C
            end else begin
                y[1] = 1; // Transition to D
            end
        3'b010: // State C
            if (~w) begin
                y[1] = 1; // Transition to E
            end else begin
                y[1] = 1; // Transition to D
            end
        3'b011: // State D
            if (~w) begin
                y[1] = 1; // Transition to F
            end else begin
                y[1] = 0; // Transition to A
            end
        3'b100: // State E
            if (~w) begin
                y[1] = 1; // Stay in E
            end else begin
                y[1] = 1; // Transition to D
            end
        3'b101: // State F
            if (~w) begin
                y[1] = 0; // Transition to C
            end else begin
                y[1] = 1; // Transition to D
            end
        default: begin
            y[1] = 1'bx; // Unknown state
        end
    endcase
end

endmodule