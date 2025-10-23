module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

wire any_byte_enable = |byteena;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else if (any_byte_enable) begin
        // Update lower byte if enabled, else retain current lower byte
        q[7:0]  <= byteena[0] ? d[7:0] : q[7:0];
        // Update upper byte if enabled, else retain current upper byte
        q[15:8] <= byteena[1] ? d[15:8] : q[15:8];
    end
    // If no byte is enabled, retain q without toggling
end

endmodule