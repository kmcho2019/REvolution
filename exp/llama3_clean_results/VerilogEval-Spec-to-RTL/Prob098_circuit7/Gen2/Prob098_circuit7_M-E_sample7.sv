module TopModule(
    input  clk,
    input  a,
    output q
);

reg [1:0] state; // Using 2-bit reg to encode 2 states: 'zero' (0) and 'one' (1)
assign q = (state == 1'b1) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    case(state)
        1'b0: // State 'zero'
            if (!a) begin
                state <= 1'b1; // Transition to 'one' if a is 0
            end else begin
                state <= 1'b0; // Stay in 'zero' if a is 1
            end
        1'b1: // State 'one'
            if (a) begin
                state <= 1'b0; // Transition to 'zero' if a is 1
            end else begin
                state <= 1'b1; // Stay in 'one' if a is 0
            end
        default:
            state <= 1'b0; // Initialize to 'zero' on reset or invalid state
    endcase
end

initial begin
    state = 1'b0; // Initialize state to 'zero' at start
end

endmodule