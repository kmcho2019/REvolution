module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] clk_gated;
    reg [7:0] stable_count;

    // Stability detection (2-bit counter per bit)
    always @(posedge clk) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            if (in[i] == prev_in[i]) begin
                stable_count[i] <= (stable_count[i] == 1'b1) ? 1'b1 : stable_count[i] + 1'b1;
            end else begin
                stable_count[i] <= 1'b0;
            end
        end
    end

    // Clock gating for stable bits
    assign clk_gated = clk & ~(stable_count & {8{1'b1}});

    // Edge detection with gated clocks
    always @(posedge clk) begin
        prev_in <= in;           // Main clock for all bits
    end

    always @(posedge clk_gated[0]) anyedge[0] <= in[0] ^ prev_in[0];
    always @(posedge clk_gated[1]) anyedge[1] <= in[1] ^ prev_in[1];
    always @(posedge clk_gated[2]) anyedge[2] <= in[2] ^ prev_in[2];
    always @(posedge clk_gated[3]) anyedge[3] <= in[3] ^ prev_in[3];
    always @(posedge clk_gated[4]) anyedge[4] <= in[4] ^ prev_in[4];
    always @(posedge clk_gated[5]) anyedge[5] <= in[5] ^ prev_in[5];
    always @(posedge clk_gated[6]) anyedge[6] <= in[6] ^ prev_in[6];
    always @(posedge clk_gated[7]) anyedge[7] <= in[7] ^ prev_in[7];

endmodule