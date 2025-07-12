module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state

// Outputs
assign disc = (state == 3'b100); // S4
assign flag = (state == 3'b101); // S5
assign err = (state == 3'b110); // S3

// State transitions
always @(*) begin
    case(state)
        3'b000: // S0
            if (in) 
                nextState = 3'b001;
            else
                nextState = 3'b000;
        3'b001: // S1
            if (in) 
                nextState = 3'b010;
            else
                nextState = 3'b000;
        3'b010: // S2
            if (in) 
                nextState = 3'b011; // error state
            else
                nextState = 3'b100; // discard
        3'b011: // S3
            if (in) 
                nextState = 3'b011;
            else
                nextState = 3'b000;
        3'b100: // S4
            nextState = 3'b000;
        3'b101: // S5
            nextState = 3'b000;
        default: // S3 (err)
            nextState = 3'b000;
    endcase
end

// State update
always @(posedge clk) begin
    if(reset) 
        state <= 3'b000;
    else
        state <= nextState;
end

endmodule