module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Extended state vector with zero padding on both sides:
    // ext_q[512+1:0] = {0, q, 0}
    // Indexing: ext_q[i+1] = q[i], ext_q[0] = 0, ext_q[513] = 0
    wire [513:0] ext_q;
    assign ext_q = {1'b0, q, 1'b0};

    // Combinational next state vector
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

    // Sequential logic: load or update state each clock rising edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule