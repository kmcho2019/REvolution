module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
parameter IDLE = 2'b00;
parameter FIRST_ONE = 2'b01;
parameter SECOND_ZERO = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(*) begin
    case (state)
        IDLE: 
            if (x) 
                next_state = FIRST_ONE;
            else 
                next_state = IDLE;
        FIRST_ONE: 
            if (!x) 
                next_state = SECOND_ZERO;
            else 
                next_state = FIRST_ONE;
        SECOND_ZERO: 
            if (x) 
                next_state = IDLE;
            else 
                next_state = SECOND_ZERO;
        default: next_state = IDLE;
    endcase
end

// State register
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) 
        state <= IDLE;
    else 
        state <= next_state;
end

// Output logic
assign z = (state == SECOND_ZERO) && x;

endmodule