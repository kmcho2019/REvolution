module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Priority encoder for next state logic
always @(*) begin
    casez ({r[0], r[1], r[2]})
        3'b1?? : next_state = 2'b01; // Device 0 has highest priority
        3'b01? : next_state = 2'b10; // Device 1 has next highest priority
        3'b001 : next_state = 2'b11; // Device 2 has lowest priority
        default: next_state = 2'b00; // No requests
    endcase
end

// State flip-flop
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else if (state == 2'b01 &&!r[0]) state <= 2'b00;
    else if (state == 2'b10 &&!r[1]) state <= 2'b00;
    else if (state == 2'b11 &&!r[2]) state <= 2'b00;
    else state <= next_state;
end

// Output assignments
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule