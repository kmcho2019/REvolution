module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // Using 1 bit to represent two states (0 and 1)
reg [0:0] next_state; // next_state is used to store the next state value

// Define the state encoding
parameter A = 1'b0;
parameter B = 1'b1;

always @(*) begin
    case(state)
        A: begin
            if (~in) next_state = B;
            else next_state = A;
            out = 1'b0;
        end
        B: begin
            if (~in) next_state = A;
            else next_state = B;
            out = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) state <= B; // Synchronous reset
    else state <= next_state;
end

endmodule