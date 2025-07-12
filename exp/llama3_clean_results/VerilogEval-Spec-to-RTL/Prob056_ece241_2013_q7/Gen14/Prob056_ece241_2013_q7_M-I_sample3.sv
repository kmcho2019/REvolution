module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic to determine the next state using a case statement
reg next_Q;
always @(*) begin
    case({j, k})
        2'b00: next_Q = Q;
        2'b01: next_Q = 1'b0;
        2'b10: next_Q = 1'b1;
        2'b11: next_Q = ~Q;
    endcase
end

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule