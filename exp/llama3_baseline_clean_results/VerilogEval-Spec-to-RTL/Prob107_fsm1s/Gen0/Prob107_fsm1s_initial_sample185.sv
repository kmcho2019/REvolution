module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Define the state variable

// Output logic
always @(*) begin
    case(state)
        0: out = 1'b1; // State B: out = 1
        1: out = 1'b0; // State A: out = 0
        default: out = 1'bx; // Invalid state
    endcase
end

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state B
    end else begin
        case(state)
            0: begin // State B
                if (!in) state <= 1; // in = 0: B -> A
                else state <= 0; // in = 1: B -> B
            end
            1: begin // State A
                if (!in) state <= 0; // in = 0: A -> B
                else state <= 1; // in = 1: A -> A
            end
            default: state <= 0; // Invalid state: reset to B
        endcase
    end
end

endmodule