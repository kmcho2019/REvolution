module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] state; // Using 2 states: 0 for q=1, 1 for q=0
initial state = 0; // Initial state set to q=1
always @(posedge clk) begin
    case(state)
        0'b0: // State where q=1
            if(a == 1'b1) begin
                state <= 1'b1; // Transition to state where q=0 when a=1
            end
        0'b1: // State where q=0
            if(a == 1'b1) begin
                state <= 1'b0; // Transition back to state where q=1 when a=1
            end
    endcase
end

always @(state) begin
    case(state)
        0'b0: q <= 1'b1; // Output q=1 in this state
        0'b1: q <= 1'b0; // Output q=0 in this state
    endcase
end

endmodule