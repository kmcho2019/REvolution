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
parameter GOT100  = 4'b1000;
// Note: GOT1001 is now distinct from IDLE

reg [3:0] current_state, next_state;
reg IN_sync, IN_prev;
wire comb_match;
wire clk_enable;

// Double flop synchronizer for IN
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        IN_sync <= 1'b0;
        IN_prev <= 1'b0;
    end else begin
        IN_sync <= IN;
        IN_prev <= IN_sync;
    end
end

// Clock gating when input hasn't changed
assign clk_enable = (IN_sync != IN_prev) || (current_state != next_state);

// State transition and reset logic with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (clk_enable) begin
        current_state <= next_state;
        MATCH <= comb_match;
    end
end

// Next state logic
always @(*) begin
    next_state = IDLE; // Default
    case (1'b1) // One-hot case statement
        current_state[0]: // IDLE
            next_state = IN_sync ? GOT1 : IDLE;
        current_state[1]: // GOT1
            next_state = IN_sync ? GOT1 : GOT10;
        current_state[2]: // GOT10
            next_state = IN_sync ? GOT1 : GOT100;
        current_state[3]: // GOT100
            next_state = IN_sync ? GOT1 : IDLE;
    endcase
end

// Mealy output - optimized combinational logic
assign comb_match = current_state[3] && IN_sync; // GOT100 state and IN=1

endmodule