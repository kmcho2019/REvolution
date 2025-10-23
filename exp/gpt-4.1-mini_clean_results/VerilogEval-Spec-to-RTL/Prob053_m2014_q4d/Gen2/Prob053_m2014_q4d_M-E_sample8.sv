module TopModule (
    input clk,
    input in,
    output out
);

    reg q;
    wire d;

    assign d = in ^ q;  // XOR logic for next state
    assign out = q;     // output driven by register

    always @(posedge clk) begin
        q <= d;
    end

endmodule