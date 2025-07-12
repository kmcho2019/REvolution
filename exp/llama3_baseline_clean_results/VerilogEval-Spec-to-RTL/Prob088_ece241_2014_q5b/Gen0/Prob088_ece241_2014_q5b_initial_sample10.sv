module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define state encoding
localparam STATE_A = 2'b10;
localparam STATE_B = 2'b01;

// Define current and next state
reg [1:0] currentState;
reg [1:0] nextState;

// Define output
reg z;

// Asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        currentState <= STATE_A;
    else
        currentState <= nextState;
end

// State transition logic
always @(*)
begin
    case(currentState)
        STATE_A:
            if(x)
                nextState = STATE_B;
            else
                nextState = STATE_A;
        STATE_B:
            nextState = STATE_B; // Stay in state B regardless of x
        default: // Should not reach here, but for simulation
            nextState = STATE_A;
    endcase
end

// Output logic
always @(*)
begin
    case(currentState)
        STATE_A:
            if(x)
                z = 1'b1;
            else
                z = 1'b0;
        STATE_B:
            if(x)
                z = 1'b0;
            else
                z = 1'b1;
        default: // Should not reach here, but for simulation
            z = 1'b0;
    endcase
end

endmodule