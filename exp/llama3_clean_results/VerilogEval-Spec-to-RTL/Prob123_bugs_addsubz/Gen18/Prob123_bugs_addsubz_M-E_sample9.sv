module hybrid_addsub_zflag #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    // Ripple-carry adder mode
    wire [WIDTH-1:0] rca_out;
    reg [WIDTH-1:0] rca_sum;
    reg rca_carry_out;

    always @(*) begin
        {rca_carry_out, rca_sum} = a + (do_sub ? ~b : b) + (do_sub ? 1'b1 : 1'b0);
    end

    assign rca_out = rca_sum;

    // Parallel prefix adder mode
    wire [WIDTH-1:0] ppa_out;
    reg [WIDTH-1:0] ppa_sum;
    reg ppa_carry_out;

    always @(*) begin
        {ppa_carry_out, ppa_sum} = a + (do_sub ? ~b : b) + (do_sub ? 1'b1 : 1'b0);
    end

    assign ppa_out = ppa_sum;

    // Hybrid adder mode selection
    reg [WIDTH-1:0] hybrid_out;
    always @(*) begin
        if (a < 8'd128 && b < 8'd128) begin
            hybrid_out = rca_out;
        end else begin
            hybrid_out = ppa_out;
        end
    end

    // Zero detection using hierarchical AND tree
    reg [3:0] segment_zeros;
    always @(*) begin
        segment_zeros[0] = ~(hybrid_out[7:4]);
        segment_zeros[1] = ~(hybrid_out[3:0]);
        segment_zeros[2] = ~(hybrid_out[7:6]);
        segment_zeros[3] = ~(hybrid_out[5:4]);
    end

    assign result_is_zero = ~(|segment_zeros);

    assign out = hybrid_out;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    hybrid_addsub_zflag #(.WIDTH(8)) u_hybrid_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule