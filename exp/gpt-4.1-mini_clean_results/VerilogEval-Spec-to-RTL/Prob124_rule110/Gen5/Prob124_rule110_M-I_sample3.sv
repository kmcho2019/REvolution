module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    localparam [7:0] RULE110 = 8'b01101110;

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            wire [2:0] pattern = {left, center, right};
            assign next_q[i] = RULE110[pattern];
        end
    endgenerate

    reg [511:0] next_q_reg;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q_reg <= 512'b0;  // or could hold q, but 0 is safe to break glitches
        end else begin
            next_q_reg <= next_q;
            q <= next_q_reg;
        end
    end

endmodule