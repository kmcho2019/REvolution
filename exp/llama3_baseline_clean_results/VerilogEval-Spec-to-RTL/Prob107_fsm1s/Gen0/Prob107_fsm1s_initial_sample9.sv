module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // 2 states: B (2'b00) and A (2'b01)
reg [1:0] next_state;

// Define the states
parameter B = 2'b00;
parameter A = 2'b01;

always @(*) begin
    case (state)
        B: begin
            if (in == 0) next_state = A;
            else next_state = B;
        end
        A: begin
            if (in == 0) next_state = B;
            else next_state = A;
        end
        default: next_state = B; // default state
    endcase
end

always @(posedge clk) begin
    if (reset) state <= B; // reset to state B
    else state <= next_state;
end

always @(*) begin
    case (state)
        B: out = 1;
        A: out = 0;
        default: out = 1; // default output
    endcase
end

endmodule