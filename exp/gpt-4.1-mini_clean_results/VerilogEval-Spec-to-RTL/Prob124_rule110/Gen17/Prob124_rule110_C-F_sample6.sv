module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded vector for easy neighborhood extraction: {0, q, 0}
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Next state combinational logic per Rule 110, expressed inline in generate loop
    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_next_state
            wire left   = ext_q[i+2];   // left neighbor of cell i
            wire center = ext_q[i+1];   // cell i itself
            wire right  = ext_q[i];     // right neighbor of cell i

            // Rule 110: next = (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Synchronous state update with load support
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule