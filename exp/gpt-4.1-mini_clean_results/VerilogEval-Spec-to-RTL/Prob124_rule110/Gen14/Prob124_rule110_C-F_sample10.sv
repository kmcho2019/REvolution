module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded extended vector to simplify neighbor access
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_update
            // Extract neighbors uniformly using vector slicing, no conditionals
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110 logic inlined:
            // next = (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule