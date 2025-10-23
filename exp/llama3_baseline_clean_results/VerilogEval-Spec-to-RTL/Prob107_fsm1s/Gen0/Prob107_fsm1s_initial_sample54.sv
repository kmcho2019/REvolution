module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter B = 1'b0;
parameter A = 1'b1;

// State register
reg current_state;
reg next_state;

// Output logic
always_comb begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx;
    endcase
end

// State transition logic
always_comb begin
    case(current_state)
        B: begin
            if (in == 1'b0) next_state = B;
            else next_state = B;
        end
        A: begin
            if (in == 1'b0) next_state = B;
            else next_state = A;
        end
        default: next_state = B;
    endcase
end

// State update on clock edge
always @(posedge clk) begin
    if (reset) current_state <= B;
    else current_state <= next_state;
end

// Initialize state
initial current_state = B;

endmodule