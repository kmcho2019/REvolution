module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot encoded states (4 states)
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;  // Merged GOT100 and GOT1001

reg [3:0] current_state, next_state;
reg IN_prev;  // For input change detection

// Input change detection
always @(posedge CLK or posedge RST) begin
    if (RST) IN_prev <= 1'b0;
    else IN_prev <= IN;
end

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered output for better timing
        MATCH <= (current_state == GOT100) && IN;
    end
end

// Next state logic with input change optimization
always @(*) begin
    if (IN == IN_prev) begin
        next_state = current_state;  // No change, hold state
    end else begin
        case (1'b1)  // One-hot case statement
            current_state[0]: next_state = IN ? GOT1 : IDLE;    // IDLE
            current_state[1]: next_state = IN ? GOT1 : GOT10;   // GOT1
            current_state[2]: next_state = IN ? GOT1 : GOT100;  // GOT10
            current_state[3]: next_state = IN ? GOT1 : GOT10;   // GOT100
            default:          next_state = IDLE;
        endcase
    end
end

endmodule