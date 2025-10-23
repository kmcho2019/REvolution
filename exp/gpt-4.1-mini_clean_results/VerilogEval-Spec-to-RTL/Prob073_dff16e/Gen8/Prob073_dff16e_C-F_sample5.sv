module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    // Split q into two 8-bit registers internally
    reg [7:0] upper_byte;
    reg [7:0] lower_byte;

    always @(posedge clk) begin
        if (!resetn) begin
            upper_byte <= 8'b0;
            lower_byte <= 8'b0;
            q <= 16'b0;
        end else begin
            // Update upper byte only if byteena[1] asserted
            if (byteena[1])
                upper_byte <= d[15:8];
            // Else retain upper_byte

            // Update lower byte only if byteena[0] asserted
            if (byteena[0])
                lower_byte <= d[7:0];
            // Else retain lower_byte

            // Combine bytes into output q
            q <= {upper_byte, lower_byte};
        end
    end

endmodule