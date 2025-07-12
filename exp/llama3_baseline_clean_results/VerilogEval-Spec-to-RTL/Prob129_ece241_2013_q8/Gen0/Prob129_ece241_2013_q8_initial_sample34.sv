module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
localparam STATE0 = 2'd0;
localparam STATE1 = 2'd1;
localparam STATE2 = 2'd2;

// Current state and next state
reg [1:0] state, next_state;

// Output
assign z = (state == STATE2) && x;

// State transition logic
always @(*) begin
    case (state)
        STATE0: 
            if (x) 
                next_state = STATE1;
            else 
                next_state = STATE0;
        STATE1: 
            if (~x) 
                next_state = STATE2;
            else 
                next_state = STATE1;
        STATE2: 
            if (x) 
                next_state = STATE1; // Go back to STATE1 to detect overlapping sequences
            else 
                next_state = STATE0;
        default:
            next_state = STATE0;
    endcase
end

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) 
        state <= STATE0;
    else 
        state <= next_state;
end

endmodule