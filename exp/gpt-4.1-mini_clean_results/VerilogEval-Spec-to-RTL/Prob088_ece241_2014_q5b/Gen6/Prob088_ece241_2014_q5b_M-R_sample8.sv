module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// State encoding (one-hot)
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

// State register
reg [1:0] state, next_state;

// Next state logic (combinational)
always @(*) begin
    case (state)
        STATE_A: next_state = x ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_B; // stays in B regardless of x
        default: next_state = STATE_A; // default safe state
    endcase
end

// Sequential state update with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= STATE_A;
    else
        state <= next_state;
end

// Mealy output logic as continuous assignment
assign z = (state == STATE_A) ? x : ~x;

endmodule