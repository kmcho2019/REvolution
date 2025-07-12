module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH,
    output reg MATCH_REG  // Optional registered output
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
        MATCH_REG <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered version of MATCH (optional)
        MATCH_REG <= (current_state == S1001) && IN;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? IDLE : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : IDLE;  // Simplified transition
        default: next_state = IDLE;
    endcase
end

// Combinational output (immediate response)
assign MATCH = (current_state == S1001) && IN;

endmodule