module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using binary encoding for states: A = 0, B = 1
reg [0:0] next_state;

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (~in)
                next_state = 1'b1; // A (0) --0--> B
            else
                next_state = 1'b0; // A (0) --1--> A
        end
        1'b1: begin // State B
            if (~in)
                next_state = 1'b0; // B (1) --0--> A
            else
                next_state = 1'b1; // B (1) --1--> B
        end
        default: next_state = 1'b1; // Default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 1'b1; // Asynchronous reset to state B
    else
        state <= next_state;
end

assign out = ~state; // Output 'out' is 1 when in state A, 0 when in state B

endmodule