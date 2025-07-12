module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state, next_state;

// Initial state assignment
initial state = 3'b000; // State A

// State encoding: A = 000, B = 001, C = 010, D = 011, E = 100, F = 101

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // Reset state to A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        3'b000: // State A
            if (~w) begin
                next_state = 3'b001; // Transition to B
                z = 0;
            end else begin
                next_state = 3'b000; // Stay in A
                z = 0;
            end
        3'b001: // State B
            if (~w) begin
                next_state = 3'b010; // Transition to C
                z = 0;
            end else begin
                next_state = 3'b011; // Transition to D
                z = 0;
            end
        3'b010: // State C
            if (~w) begin
                next_state = 3'b100; // Transition to E
                z = 0;
            end else begin
                next_state = 3'b011; // Transition to D
                z = 0;
            end
        3'b011: // State D
            if (~w) begin
                next_state = 3'b101; // Transition to F
                z = 0;
            end else begin
                next_state = 3'b000; // Transition to A
                z = 0;
            end
        3'b100: // State E
            if (~w) begin
                next_state = 3'b100; // Stay in E
                z = 1;
            end else begin
                next_state = 3'b011; // Transition to D
                z = 1;
            end
        3'b101: // State F
            if (~w) begin
                next_state = 3'b010; // Transition to C
                z = 1;
            end else begin
                next_state = 3'b011; // Transition to D
                z = 1;
            end
        default:
            next_state = 3'b000; // Default to A
            z = 0;
    endcase
end

endmodule