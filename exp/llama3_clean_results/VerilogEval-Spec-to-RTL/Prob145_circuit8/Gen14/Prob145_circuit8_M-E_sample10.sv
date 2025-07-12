module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state = 0; // 0: idle, 1: active low, 2: active high
reg prev_a = 0; // Register to keep track of previous 'a'

always @(posedge clock) begin
    prev_a <= a; // Update prev_a on every clock cycle
    case(state)
        0: if (clock && a) state <= 2; // Transition from idle to active high
        1: if (clock && a) state <= 2; else if (!clock) state <= 0; // Transition from active low to active high or back to idle
        2: if (!clock) state <= 1; // Transition from active high to active low
        default: state <= 0; // Default back to idle
    endcase
end

always @(*) begin
    case(state)
        0: begin p = 0; q = 0; end // Idle state
        1: begin p = 0; q = 1; end // Active low state
        2: begin p = 1; q = 1; end // Active high state
        default: begin p = 0; q = 0; end // Default to idle
    endcase
end

endmodule