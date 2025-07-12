module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

// Declare the current state and next state
reg current_state;
reg next_state;

// Initial state
initial begin
    current_state = B;
end

// State transitions
always @(*) begin
    case(current_state)
        A: begin
            if (!in) next_state = B;
            else next_state = A;
        end
        B: begin
            if (!in) next_state = A;
            else next_state = B;
        end
        default: next_state = B;
    endcase
end

// Output generation
always @(*) begin
    case(current_state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b1;
    endcase
end

// State update
always @(posedge clk) begin
    if (reset) current_state <= B;
    else current_state <= next_state;
end

endmodule