module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

// The current state is y, and we need to determine the next state
// based on the given transitions. We will use the state codes:
// A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

// We are only implementing the next-state logic for y[1]
// So we will consider the current state of y[1] and the input w
// to determine the next state of y[1]

// Output Y1 is directly assigned the value of y[1]
assign Y1 = y[1];

// Next-state logic for y[1]
// We will use a case statement to simplify the logic
always @(y, w) begin
    case (y)
        3'b000: // State A
            if (~w) begin
                // A (0) --0--> B, so y[1] becomes 0
                y[1] <= 0;
            end else begin
                // A (0) --1--> A, so y[1] remains 0
                y[1] <= 0;
            end
        3'b001: // State B
            if (~w) begin
                // B (0) --0--> C, so y[1] becomes 1
                y[1] <= 1;
            end else begin
                // B (0) --1--> D, so y[1] becomes 1
                y[1] <= 1;
            end
        3'b010: // State C
            if (~w) begin
                // C (0) --0--> E, so y[1] becomes 0
                y[1] <= 0;
            end else begin
                // C (0) --1--> D, so y[1] becomes 1
                y[1] <= 1;
            end
        3'b011: // State D
            if (~w) begin
                // D (0) --0--> F, so y[1] becomes 1
                y[1] <= 1;
            end else begin
                // D (0) --1--> A, so y[1] becomes 0
                y[1] <= 0;
            end
        3'b100: // State E
            if (w) begin
                // E (1) --0--> E, so y[1] remains 0
                y[1] <= 0;
            end else begin
                // E (1) --1--> D, so y[1] becomes 1
                y[1] <= 1;
            end
        3'b101: // State F
            if (w) begin
                // F (1) --0--> C, so y[1] becomes 1
                y[1] <= 1;
            end else begin
                // F (1) --1--> D, so y[1] becomes 1
                y[1] <= 1;
            end
        default: begin
            y[1] <= 0; // Default value for y[1]
        end
    endcase
end

endmodule