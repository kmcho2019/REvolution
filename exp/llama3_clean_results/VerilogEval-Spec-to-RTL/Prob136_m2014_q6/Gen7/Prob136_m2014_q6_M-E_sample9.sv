module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState;

// State transition and output lookup table
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        case ({currentState, w})
            {A, 1'b0}: begin currentState <= B; z <= 0; end
            {A, 1'b1}: begin currentState <= A; z <= 0; end
            {B, 1'b0}: begin currentState <= C; z <= 0; end
            {B, 1'b1}: begin currentState <= D; z <= 0; end
            {C, 1'b0}: begin currentState <= E; z <= 0; end
            {C, 1'b1}: begin currentState <= D; z <= 0; end
            {D, 1'b0}: begin currentState <= F; z <= 0; end
            {D, 1'b1}: begin currentState <= A; z <= 0; end
            {E, 1'b0}: begin currentState <= E; z <= 1; end
            {E, 1'b1}: begin currentState <= D; z <= 1; end
            {F, 1'b0}: begin currentState <= C; z <= 1; end
            {F, 1'b1}: begin currentState <= D; z <= 1; end
            default: begin currentState <= A; z <= 0; end
        endcase
    end
end

endmodule