module TopModule (
    input clk,
    input in,
    output out
);

    reg q = 0;     // initialize to 0 to avoid unknown startup state
    wire d;

    assign d = in ^ q;  // XOR logic for next state
    assign out = q;     // output driven by register

    always @(posedge clk) begin
        q <= d;
    end

endmodule