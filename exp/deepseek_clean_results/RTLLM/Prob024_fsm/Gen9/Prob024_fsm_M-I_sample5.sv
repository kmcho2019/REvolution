module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot encoded states for better timing
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;

reg [3:0] current_state, next_state;
reg IN_prev, clk_en;

// Clock gating control
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        IN_prev <= 1'b0;
    end else begin
        IN_prev <= IN;
    end
end

assign clk_en = RST | (IN != IN_prev);

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (clk_en) begin
        current_state <= next_state;
        // Output is 1 only when in GOT100 state and IN is 1
        MATCH <= (current_state == GOT100) && IN;
    end
end

// Optimized next state logic
always @(*) begin
    next_state = IDLE;  // Default assignment
    
    case (1'b1)  // Synopsys parallel_case
        current_state[0]: // IDLE
            next_state = IN ? GOT1 : IDLE;
        current_state[1]: // GOT1
            next_state = IN ? GOT1 : GOT10;
        current_state[2]: // GOT10
            next_state = IN ? GOT1 : GOT100;
        current_state[3]: // GOT100
            next_state = IN ? GOT1 : GOT10;
    endcase
end

endmodule