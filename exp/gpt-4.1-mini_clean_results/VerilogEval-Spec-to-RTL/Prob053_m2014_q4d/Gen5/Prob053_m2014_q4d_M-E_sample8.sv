module TopModule (
    input  clk,
    input  in,
    output out
);

    reg q;

    // combinational XOR of 'in' and current state 'q'
    wire d = in ^ q;

    always @(posedge clk) begin
        q <= d;
    end

    assign out = q;

endmodule