module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

    wire [3:0] select;
    assign select = c[1:0];

    wire [3:0] mux_out;
    always @(*) begin
        case (select)
            2'd0: mux_out = b;
            2'd1: mux_out = e;
            2'd2: mux_out = a;
            2'd3: mux_out = d;
            default: mux_out = 4'd15; // This could be optimized to a more specific value if 'f' is defined
        endcase
    end

    assign q = (c[3] == 1'b0) ? mux_out : 4'd15;

endmodule