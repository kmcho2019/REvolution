module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended vector with zero padding at both ends simplifies boundary conditions
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            // Neighborhood bits for cell i: left = ext_q[i+2], center = ext_q[i+1], right = ext_q[i]
            wire left   = ext_q[i + 2];
            wire center = ext_q[i + 1];
            wire right  = ext_q[i];
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