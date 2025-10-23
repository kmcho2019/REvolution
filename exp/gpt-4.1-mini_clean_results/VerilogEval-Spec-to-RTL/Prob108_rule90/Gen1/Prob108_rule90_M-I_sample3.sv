module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90_logic
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule