module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // current state
reg [1:0] next_state; // next state

// state table
always @(*)
begin
    case (state)
        2'b00: // state A
            if (r[0])
                next_state = 2'b01;
            else if (r[1])
                next_state = 2'b10;
            else if (r[2])
                next_state = 2'b11;
            else
                next_state = 2'b00;
        2'b01: // state B
            next_state = r[0] ? 2'b01 : 2'b00;
        2'b10: // state C
            next_state = r[1] ? 2'b10 : 2'b00;
        2'b11: // state D
            next_state = r[2] ? 2'b11 : 2'b00;
        default:
            next_state = 2'b00;
    endcase
end

// state flip-flops
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;
    else
        state <= next_state;
end

// output g
assign g[0] = (state == 2'b01) && r[0];
assign g[1] = (state == 2'b10) && r[1];
assign g[2] = (state == 2'b11) && r[2];

endmodule