module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

// Extract byte enables for clarity
wire upper_en = byteena[1];
wire lower_en = byteena[0];

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update upper byte if enabled, else hold
        if (upper_en)
            q[15:8] <= d[15:8];
        // else q[15:8] <= q[15:8]; implicitly held

        // Update lower byte if enabled, else hold
        if (lower_en)
            q[7:0] <= d[7:0];
        // else q[7:0] <= q[7:0]; implicitly held
    end
end

endmodule