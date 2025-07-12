module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;
    localparam [7:0] RULE110 = 8'b01101110; // Rule 110 pattern, indexed by {left, center, right}

    reg left, center, right;
    integer idx;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with zero boundary conditions
            left   = (i < 511) ? q[i+1] : 1'b0;
            center = q[i];
            right  = (i > 0)   ? q[i-1] : 1'b0;

            idx = {left, center, right};
            next_q[i] = RULE110[idx];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule