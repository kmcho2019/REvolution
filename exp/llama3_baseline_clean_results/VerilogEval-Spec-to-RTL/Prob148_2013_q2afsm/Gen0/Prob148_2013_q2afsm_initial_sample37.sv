module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

// Current and next state
reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*)
begin
    case (current_state)
        STATE_A:
            if (r[0] == 1'b1)
                next_state = STATE_B;
            else if (r[1] == 1'b1)
                next_state = STATE_C;
            else if (r[2] == 1'b1)
                next_state = STATE_A; // Based on the description, no explicit transition is defined for r2=1 from A, so stay in A
            else
                next_state = STATE_A;
        STATE_B:
            if (r[0] == 1'b1)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        STATE_C:
            if (r[1] == 1'b1)
                next_state = STATE_C;
            else
                next_state = STATE_A;
        default:
            next_state = STATE_A; // Default to state A for any other condition
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn)
        current_state <= STATE_A;
    else
        current_state <= next_state;
end

// Output logic
assign g[0] = (current_state == STATE_B);
assign g[1] = (current_state == STATE_C);
assign g[2] = 1'b0; // Since there's no specific condition for g2 to be 1 in the given description

endmodule