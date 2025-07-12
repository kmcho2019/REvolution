module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic to determine the next state
reg next_Q;
always @(*) begin
    if (j == 1'b0) begin
        next_Q = (k == 1'b0) ? Q : 1'b0;
    end else begin
        next_Q = (k == 1'b0) ? 1'b1 : ~Q;
    end
end

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule