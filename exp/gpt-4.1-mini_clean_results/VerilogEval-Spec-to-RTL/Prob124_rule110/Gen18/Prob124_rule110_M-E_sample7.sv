module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended state vector with padding zeros at both ends for boundary conditions
    wire [513:0] ext_q; // ext_q[513] = 0, ext_q[512:1] = q[511:0], ext_q[0] = 0
    assign ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_logic
            wire left   = ext_q[i + 2]; // q[i+1], zero if i=511
            wire center = ext_q[i + 1]; // q[i]
            wire right  = ext_q[i];     // q[i-1], zero if i=0

            // Rule 110 boolean function (from truth table):
            // next = (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule