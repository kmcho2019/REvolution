module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage

    // XOR gate and flip-flop implementation
    always @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule