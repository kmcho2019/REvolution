module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0] q
);
    reg [3:0] q_low, q_high;

    always @(negedge clk) begin
        if (reset) begin
            q_low  <= 4'h4; // Lower nibble of 0x34
            q_high <= 4'h3; // Upper nibble of 0x34
        end else begin
            q_low  <= d[3:0];
            q_high <= d[7:4];
        end
    end

    // Concatenate the two halves to form the 8-bit output
    always @(*) begin
        q = {q_high, q_low};
    end
endmodule