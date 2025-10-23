module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter B = 1'b0, A = 1'b1;

// Reg variable to hold the current state
reg current_state;

// Reg variable to hold the next state
reg next_state;

// Always block for combinational logic
always @(*)
begin
    case(current_state)
        B: 
        begin
            out = 1'b1;
            if (in == 1'b0)
                next_state = B;
            else
                next_state = B;
        end
        A: 
        begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        end
        default: next_state = B;
    endcase
end

// Always block for sequential logic
always @(posedge clk)
begin
    if (reset)
        current_state <= B;
    else
        current_state <= next_state;
end

endmodule