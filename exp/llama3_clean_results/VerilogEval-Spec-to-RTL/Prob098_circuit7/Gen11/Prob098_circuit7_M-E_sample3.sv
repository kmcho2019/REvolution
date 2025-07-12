module TopModule(
    input clk,
    input a,
    output reg q
);

// Define the states of the FSM
enum logic [0:0] {S_HIGH, S_LOW} state, next_state;

// Initialize the output and state
initial begin
    state = S_HIGH;
    q = 1'b1;
end

// FSM logic
always @(posedge clk) begin
    state = next_state;
    case (state)
        S_HIGH: begin
            q = 1'b1;
            if (a) next_state = S_LOW;
            else next_state = S_HIGH;
        end
        S_LOW: begin
            q = 1'b0;
            if (!a) next_state = S_HIGH;
            else next_state = S_LOW;
        end
    endcase
end

endmodule