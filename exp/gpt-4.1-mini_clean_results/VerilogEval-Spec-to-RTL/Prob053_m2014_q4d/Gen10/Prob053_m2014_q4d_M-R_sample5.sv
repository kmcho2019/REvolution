module TopModule (
    input  clk,
    input  in,
    output out
);

    reg q;
    reg next_state;

    // Combinational logic for next_state
    always @(*) begin
        next_state = in ^ q;
    end

    // Sequential logic: flip-flop capture
    always @(posedge clk) begin
        q = next_state;  // blocking assignment inside always @(posedge clk)
    end

    assign out = q;

endmodule