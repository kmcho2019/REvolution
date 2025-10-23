module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // Using two-bit encoding for two states
reg [1:0] next_state;

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (~in) next_state = 1'b1; // A (out=0) --in=0--> B
            else next_state = 1'b0; // A (out=0) --in=1--> A
        end
        1'b1: begin // State B
            if (~in) next_state = 1'b1; // B (out=1) --in=0--> B
            else next_state = 1'b1; // B (out=1) --in=1--> B
        end
        default: next_state = 1'b1; // Default state is B
    endcase
end

always @(posedge clk) begin
    if (reset) state <= 1'b1; // Reset to state B
    else state <= next_state;
end

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // State A, output is 0
        1'b1: out = 1'b1; // State B, output is 1
        default: out = 1'b1; // Default output is 1 (state B)
    endcase
end

endmodule