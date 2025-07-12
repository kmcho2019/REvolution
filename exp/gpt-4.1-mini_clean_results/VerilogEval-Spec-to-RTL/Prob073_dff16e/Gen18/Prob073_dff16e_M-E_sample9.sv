module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

// Separate the 16-bit register into two 8-bit registers with individual enables
reg [7:0] q_low;
reg [7:0] q_high;

always @(posedge clk) begin
    if (!resetn) begin
        q_low  <= 8'b0;
        q_high <= 8'b0;
    end else begin
        if (byteena[0])
            q_low <= d[7:0];
        // else retain previous value (no else needed because q_low holds its value)

        if (byteena[1])
            q_high <= d[15:8];
        // else retain previous value
    end
end

// Combine output bytes into the 16-bit output
always @(*) begin
    q = {q_high, q_low};
end

endmodule