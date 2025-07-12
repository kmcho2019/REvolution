module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    localparam [7:0] RULE110 = 8'b01101110;

    reg [511:0] next_q;

    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Fetch neighbors with zero boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            next_q[i] = RULE110[{left, center, right}];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule