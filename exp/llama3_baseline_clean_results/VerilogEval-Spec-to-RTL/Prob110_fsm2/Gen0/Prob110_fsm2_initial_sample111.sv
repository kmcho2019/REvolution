module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] next_state; // 1-bit signal to represent the next state

// State encoding: OFF = 0, ON = 1
localparam OFF = 1'b0;
localparam ON = 1'b1;

// Output logic
assign out = state;

// State transition logic
always @(*) begin
    case(state)
        OFF: 
            if(j) 
                next_state = ON;
            else 
                next_state = OFF;
        ON: 
            if(k) 
                next_state = OFF;
            else 
                next_state = ON;
        default: 
            next_state = OFF;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if(areset) 
        state <= OFF;
    else 
        state <= next_state;
end

endmodule