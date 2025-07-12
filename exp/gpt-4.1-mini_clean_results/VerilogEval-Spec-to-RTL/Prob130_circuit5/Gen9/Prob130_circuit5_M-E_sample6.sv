module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    wire [3:0] mux_inputs [3:0];
    assign mux_inputs[0] = b;
    assign mux_inputs[1] = e;
    assign mux_inputs[2] = a;
    assign mux_inputs[3] = d;

    always @(*) begin
        if (c < 4)
            q = mux_inputs[c[1:0]];
        else
            q = 4'hF;
    end

endmodule