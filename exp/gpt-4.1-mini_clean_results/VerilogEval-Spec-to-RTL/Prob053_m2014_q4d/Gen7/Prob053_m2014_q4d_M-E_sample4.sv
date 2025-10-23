module TopModule (
    input  clk,
    input  in,
    output out
);

    reg stage1;
    reg stage2;
    wire next_state;

    // Compute next_state as XOR of input and current state (stage1)
    assign next_state = in ^ stage1;

    always @(posedge clk) begin
        stage1 <= stage2;      // stage1 holds current state (out)
        stage2 <= next_state;  // stage2 holds next state (D input)
    end

    assign out = stage1;

endmodule