module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    wire [15:0] masked_d;
    wire [15:0] next_q;

    // Construct masked input based on byte enables:
    // For each byte, if enabled, take new data; else keep old q bits.
    assign masked_d[7:0]   = byteena[0] ? d[7:0]   : q[7:0];
    assign masked_d[15:8]  = byteena[1] ? d[15:8]  : q[15:8];
    assign next_q = masked_d;

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            q <= next_q;
    end

endmodule