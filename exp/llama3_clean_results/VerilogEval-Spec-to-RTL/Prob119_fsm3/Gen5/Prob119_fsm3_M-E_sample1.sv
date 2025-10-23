module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 1'b1;
parameter B = 1'b2;
parameter C = 1'b3;
parameter D = 1'b4;

// State flags
reg [0:3] state_flags;
reg [0:3] next_state_flags;

// Next state logic
always @(*)
begin
    next_state_flags[0] = (state_flags[0] &&!in) || (state_flags[2] &&!in);
    next_state_flags[1] = (state_flags[0] && in) || (state_flags[1] && in) || (state_flags[3] && in);
    next_state_flags[2] = (state_flags[1] &&!in);
    next_state_flags[3] = (state_flags[2] && in) || (state_flags[3] &&!in);
end

// Output logic
assign out = state_flags[3];

// State register with synchronous reset
always @(posedge clk)
begin
    if(areset)
    begin
        state_flags[0] <= 1'b1;
        state_flags[1] <= 1'b0;
        state_flags[2] <= 1'b0;
        state_flags[3] <= 1'b0;
    end
    else
    begin
        state_flags[0] <= next_state_flags[0];
        state_flags[1] <= next_state_flags[1];
        state_flags[2] <= next_state_flags[2];
        state_flags[3] <= next_state_flags[3];
    end
end

endmodule