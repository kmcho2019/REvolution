module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended vector with zero-padding at both ends to simplify neighborhood extraction
    wire [513:0] ext_q = {1'b0, q, 1'b0};
    wire [511:0] next_q;

    // Rule 110 next state function: next = (~left & center) | (center ^ right)
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_next_state
            wire left   = ext_q[i+2];   // left neighbor
            wire center = ext_q[i+1];   // current cell
            wire right  = ext_q[i];     // right neighbor
            assign next_q[i] = rule110_cell(left, center, right);
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