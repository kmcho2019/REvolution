module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter STATE_B = 1'b0;
parameter STATE_A = 1'b1;

reg current_state;
reg next_state;

// Output logic
always @(*) begin
    case(current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'bx; // Don't care
    endcase
end

// Next state logic
always @(*) begin
    case(current_state)
        STATE_B: if (in == 1'b0) next_state = STATE_A;
                 else next_state = STATE_B;
        STATE_A: if (in == 1'b0) next_state = STATE_B;
                 else next_state = STATE_A;
        default: next_state = STATE_B; // Don't care
    endcase
end

// State update logic
always @(posedge clk) begin
    if (reset == 1'b1) begin
        current_state <= STATE_B;
    end else begin
        current_state <= next_state;
    end
end

endmodule