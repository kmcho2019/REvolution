module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    integer i;
    reg [511:0] next_q;

    always @(*) begin
        // Compute next state for all 512 cells
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors, zero outside boundaries
            wire left   = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right  = (i > 0)   ? q[i-1] : 1'b0;
            // Apply Rule 110 logic: next = (~left & center) | (center ^ right);
            next_q[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule