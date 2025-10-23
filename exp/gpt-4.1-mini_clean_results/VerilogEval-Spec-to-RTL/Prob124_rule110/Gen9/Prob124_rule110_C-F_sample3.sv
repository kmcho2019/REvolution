module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded extended vector to simplify boundary neighbor access
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            // Extract neighbors from extended vector
            wire left   = ext_q[i+2];   // left neighbor of cell i
            wire center = ext_q[i+1];   // current cell i
            wire right  = ext_q[i];     // right neighbor of cell i

            // Rule 110 next state logic as simplified boolean expression:
            // next = (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Sequential logic: synchronous load or state update on positive clock edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule