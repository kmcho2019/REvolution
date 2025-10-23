module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    reg next_out;

    // Combinational logic to compute next output value
    always @(*) begin
        next_out = in ^ out;
    end

    // Sequential logic: D flip-flop with no reset
    always @(posedge clk) begin
        out <= next_out;
    end

endmodule