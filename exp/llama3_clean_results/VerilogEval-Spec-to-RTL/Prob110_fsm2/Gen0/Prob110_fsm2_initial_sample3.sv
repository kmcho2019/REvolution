module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [1:0] state; // Two states: OFF and ON
parameter OFF = 2'b00, ON = 2'b01;

always @(*) begin
    case(state)
        OFF: if (j) state = ON;
             else state = OFF;
        ON:  if (k) state = OFF;
             else state = ON;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= OFF;
    else state <= state;
end

always @(state) begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

endmodule