module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire d;

    assign d = in ^ state;  // combinational XOR
    assign out = state;     // output from state

    always @(posedge clk) begin
        state <= d;         // flip-flop capturing XOR output
    end

endmodule