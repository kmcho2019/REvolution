module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

    wire [15:0] byte_mask;
    assign byte_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            // For bytes enabled, update q with d; else hold old q value
            q <= (q & ~byte_mask) | (d & byte_mask);
    end

endmodule