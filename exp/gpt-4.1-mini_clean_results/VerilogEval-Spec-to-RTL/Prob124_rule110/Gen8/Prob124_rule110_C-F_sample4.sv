module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended vector with zero padding at both ends to simplify neighborhood extraction
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : compute_next_state
            wire left   = ext_q[i+2];   // left neighbor (i+1)
            wire center = ext_q[i+1];   // current cell i
            wire right  = ext_q[i];     // right neighbor (i-1)

            // Rule 110 next state logic:
            // next = (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule