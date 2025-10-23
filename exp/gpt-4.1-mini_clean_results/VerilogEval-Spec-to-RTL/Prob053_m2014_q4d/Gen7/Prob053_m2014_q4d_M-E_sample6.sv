module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire d;

    assign d = in ^ state;  // XOR combinational logic

    always @(posedge clk) begin
        state <= d;          // D flip-flop sampling XOR result
    end

    assign out = state;      // Output driven by flip-flop state

endmodule