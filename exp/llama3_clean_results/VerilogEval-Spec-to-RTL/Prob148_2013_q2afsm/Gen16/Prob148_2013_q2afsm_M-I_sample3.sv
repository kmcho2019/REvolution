module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Simplified next state logic
always @(*) begin
    case (state)
        2'b00: begin
            if (r[0]) next_state = 2'b01;
            else if (r[1]) next_state = 2'b10;
            else if (r[2]) next_state = 2'b11;
            else next_state = 2'b00; // Stay in current state if no requests
        end
        2'b01: if (r[0]) next_state = 2'b01; else next_state = 2'b00;
        2'b10: if (r[1]) next_state = 2'b10; else next_state = 2'b00;
        2'b11: if (r[2]) next_state = 2'b11; else next_state = 2'b00;
    endcase
end

// State flip-flop with synchronous reset
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else state <= next_state;
end

// Output assignments based on state
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule