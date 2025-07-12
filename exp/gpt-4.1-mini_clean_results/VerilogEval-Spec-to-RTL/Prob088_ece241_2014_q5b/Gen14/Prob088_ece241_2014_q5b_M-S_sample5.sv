module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic
always @(*) begin
    // Default: no transition
    next_state_A = state_A;
    next_state_B = state_B;
    
    if (state_A) begin
        if (x == 1'b0) begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end else begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
    end else begin // state_B is active
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end
end

// Output logic (Mealy)
always @(*) begin
    if (state_A)
        z = x;       // z=0 if x=0, z=1 if x=1
    else
        z = ~x;      // z=1 if x=0, z=0 if x=1
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule