module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot state encoding for simpler logic
localparam [3:0]
    IDLE    = 4'b0001,
    GOT1    = 4'b0010,
    GOT10   = 4'b0100,
    GOT100  = 4'b1000;

reg [3:0] current_state, next_state;
reg IN_prev;
wire input_changed = (IN != IN_prev);
wire next_match;

// Input change detection for clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        IN_prev <= 1'b0;
    end else begin
        IN_prev <= IN;
    end
end

// State register and output update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (input_changed) begin  // Only update when input changes
        current_state <= next_state;
        MATCH <= next_match;
    end
end

// Combinational next state logic (simpler with one-hot)
always @(*) begin
    next_state = IDLE;  // Default
    case (1'b1)
        current_state[0]: next_state = IN ? GOT1 : IDLE;
        current_state[1]: next_state = IN ? GOT1 : GOT10;
        current_state[2]: next_state = IN ? GOT1 : GOT100;
        current_state[3]: next_state = IN ? GOT1 : GOT10;
    endcase
end

// Combinational Mealy output
assign next_match = current_state[3] && IN;

endmodule