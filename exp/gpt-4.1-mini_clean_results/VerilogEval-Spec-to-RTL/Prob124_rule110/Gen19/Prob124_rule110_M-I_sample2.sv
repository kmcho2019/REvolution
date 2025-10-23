module BitRegister512CE (
    input  wire         clk,
    input  wire         ce,
    input  wire         load,
    input  wire [511:0] d,
    output reg  [511:0] q
);
    always @(posedge clk) begin
        if (ce) begin
            if (load)
                q <= d;
            else
                q <= d;  // 'd' here is next state passed from TopModule
        end
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    // Internal state register
    reg [511:0] state_q;

    // Zero-padding boundaries for next state computation
    wire [513:0] ext_q = {1'b0, state_q, 1'b0};

    // Compute next state combinationally
    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_logic
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Determine clock enable: update only if load asserted or state changes
    wire ce = load | (next_q != state_q);

    // Instantiate register with clock enable
    BitRegister512CE state_reg (
        .clk  (clk),
        .ce   (ce),
        .load (load),
        .d    (load ? data : next_q),
        .q    (state_q)
    );

    assign q = state_q;

endmodule