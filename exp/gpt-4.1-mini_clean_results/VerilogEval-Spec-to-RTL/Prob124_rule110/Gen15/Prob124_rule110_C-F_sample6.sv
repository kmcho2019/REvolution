module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended state with zero padding for boundary conditions: q[-1] = 0 and q[512] = 0
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_calc
            // Extract neighbors using the zero-padded ext_q
            wire left   = ext_q[i+2];   // q[i+1], zero at boundary
            wire center = ext_q[i+1];   // q[i]
            wire right  = ext_q[i];     // q[i-1], zero at boundary

            // Rule 110 next state logic:
            // next_state[i] = (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule