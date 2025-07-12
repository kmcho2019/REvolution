module BitRegister512 (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] d,
    output reg  [511:0] q
);
    always @(posedge clk) begin
        if (load)
            q <= d;
        else
            q <= q; // Hold state if no load; q updates outside this module
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    // Internal register to hold state with load capability
    reg [511:0] state_q;

    // Zero-padding at boundaries: {0, q, 0}
    wire [513:0] ext_q = {1'b0, state_q, 1'b0};

    // Combinational next state logic per Rule 110 (direct expressions)
    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_logic
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110: next = (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Sequential update logic with load
    always @(posedge clk) begin
        if (load)
            state_q <= data;
        else
            state_q <= next_q;
    end

    assign q = state_q;

endmodule