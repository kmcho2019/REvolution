module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state; // 0=OFF, 1=ON
    wire next_state;

    assign next_state = reset ? 1'b0 : (state ^ (state ? k : j));

    always @(posedge clk) begin
        state <= next_state;
    end

    assign out = state;

endmodule