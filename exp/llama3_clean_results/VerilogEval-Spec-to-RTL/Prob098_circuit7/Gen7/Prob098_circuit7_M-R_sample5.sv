module TopModule(
    input clk,
    input a,
    output reg q
);

reg next_q;

// Combinational logic to determine the next state of q
always @(*) begin
    if (a) begin
        next_q = 0;
    end else begin
        next_q = 1;
    end
end

// Sequential logic to update q at the positive edge of clk
always @(posedge clk) begin
    q <= next_q;
end

endmodule