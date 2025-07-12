module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [1:0] state, next_state;

// Assign the initial state
initial state = S0;

// Asynchronous reset
always @(posedge aresetn or negedge clk)
begin
    if (~aresetn)
        state <= S0;
    else if (clk)
        state <= next_state;
end

// Next state and output logic
always @(*)
begin
    next_state = state;
    z = 1'b0;

    case (state)
        S0: 
            if (x)
                next_state = S1;
        S1: 
            if (~x)
                next_state = S2;
            else
                next_state = S1;
        S2: 
            if (x)
            begin
                z = 1'b1; // assert z when sequence "101" is detected
                next_state = S2; // stay in S2 to recognize overlapping sequences
            end
            else
                next_state = S0;
    endcase
end

endmodule