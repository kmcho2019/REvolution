module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define the states of the FSM
parameter IDLE = 4'd0, 
           MATCH_1 = 4'd1, 
           MATCH_11 = 4'd2, 
           MATCH_110 = 4'd3, 
           MATCH_1101 = 4'd4;

// Declare the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Output register
reg start_shifting_reg;

// Initialize the current state
initial current_state = IDLE;

// Combinational logic for state transitions
always @(*)
begin
    case (current_state)
        IDLE:
            if (data == 1) 
                next_state = MATCH_1;
            else 
                next_state = IDLE;
        MATCH_1:
            if (data == 1) 
                next_state = MATCH_11;
            else 
                next_state = IDLE;
        MATCH_11:
            if (data == 0) 
                next_state = MATCH_110;
            else 
                next_state = MATCH_1;
        MATCH_110:
            if (data == 1) 
                next_state = MATCH_1101;
            else 
                next_state = IDLE;
        MATCH_1101:
            next_state = MATCH_1101;
        default:
            next_state = IDLE;
    endcase
end

// Sequential logic for state updates and output
always @(posedge clk)
begin
    if (reset) 
    begin
        current_state <= IDLE;
        start_shifting_reg <= 0;
    end 
    else 
    begin
        current_state <= next_state;
        if (current_state == MATCH_1101) 
            start_shifting_reg <= 1;
        else if (current_state!= MATCH_1101 && start_shifting_reg == 1)
            start_shifting_reg <= 1;
        else
            start_shifting_reg <= 0;
    end
end

// Continuous assignment for output
assign start_shifting = start_shifting_reg;

endmodule