module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Mask for byte enables: upper byteena[1], lower byteena[0]
            // Construct a 16-bit mask by replicating byteena bits to corresponding bytes
            // Then selectively update q using the mask; else retain previous q bits.
            q <= (q & ~({{8{byteena[1]}}, {8{byteena[0]}}})) | (d & {{8{byteena[1]}}, {8{byteena[0]}}});
        end
    end

endmodule