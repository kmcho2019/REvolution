module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// One-hot encoded states
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;

reg [3:0] current_state, next_state;

// State transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (1'b1) // synthesis parallel_case
        current_state[0]: next_state = IN ? GOT1 : IDLE;    // IDLE
        current_state[1]: next_state = IN ? GOT1 : GOT10;   // GOT1
        current_state[2]: next_state = IN ? GOT1 : GOT100;  // GOT10
        current_state[3]: next_state = IN ? GOT1 : GOT10;   // GOT100
        default:         next_state = IDLE;
    endcase
end

// Output logic - combinational
assign MATCH = (current_state == GOT100) & IN;

endmodule