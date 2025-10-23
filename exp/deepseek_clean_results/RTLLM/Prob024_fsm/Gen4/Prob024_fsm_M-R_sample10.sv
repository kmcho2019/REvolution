module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH
);

// State encoding
localparam [2:0] IDLE  = 3'b000;
localparam [2:0] S1    = 3'b001;
localparam [2:0] S10   = 3'b010;
localparam [2:0] S100  = 3'b011;
localparam [2:0] S1001 = 3'b100;

reg [2:0] current_state;
reg [2:0] next_state;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? IDLE : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic - Mealy style (depends on current state AND input)
assign MATCH = (current_state == S1001) && IN;

endmodule