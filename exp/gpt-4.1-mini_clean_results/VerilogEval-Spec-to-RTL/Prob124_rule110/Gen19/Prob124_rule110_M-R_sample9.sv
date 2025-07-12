module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Extended state vector with zero-padding at boundaries: q_ext[513:0]
    // q_ext[0] = 0 (left boundary),
    // q_ext[1 to 512] = q[0 to 511],
    // q_ext[513] = 0 (right boundary)
    wire [513:0] q_ext;
    assign q_ext = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_all_cells
            wire left   = q_ext[i+2]; // left neighbor of cell i
            wire center = q_ext[i+1]; // current cell i
            wire right  = q_ext[i];   // right neighbor of cell i

            // Rule 110 logic: next = (~left & center) | (center ^ right);
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