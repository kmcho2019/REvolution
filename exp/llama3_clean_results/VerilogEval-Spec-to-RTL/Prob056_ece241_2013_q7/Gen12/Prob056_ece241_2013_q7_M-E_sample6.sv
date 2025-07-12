module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0
);

// Combinational logic to determine the next state
always @(*) begin
    case({j, k})
        2'b00: Q = Q; // No change
        2'b01: Q = 1'b0;
        2'b10: Q = 1'b1;
        2'b11: Q = ~Q;
    endcase
end

// D flip-flop to store the state
always @(posedge clk) begin
    Q <= Q;
end

endmodule