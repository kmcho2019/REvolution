module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

reg [7:0] upper_byte;
reg [7:0] lower_byte;

always @(posedge clk) begin
    if (!resetn) begin
        upper_byte <= 8'b0;
        lower_byte <= 8'b0;
    end else begin
        // Update upper byte only if byteena[1] is set
        if (byteena[1])
            upper_byte <= d[15:8];
        // Otherwise retain previous value

        // Update lower byte only if byteena[0] is set
        if (byteena[0])
            lower_byte <= d[7:0];
        // Otherwise retain previous value
    end
end

// Combine upper and lower bytes into output
always @(*) begin
    q = {upper_byte, lower_byte};
end

endmodule