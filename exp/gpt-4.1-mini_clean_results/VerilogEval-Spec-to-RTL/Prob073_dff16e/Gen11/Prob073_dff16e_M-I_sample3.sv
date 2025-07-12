module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

wire clk_en = |byteena;  // Enable register update only if any byte is enabled

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else if (clk_en) begin
        // Conditionally update lower byte
        q[7:0]  <= byteena[0] ? d[7:0] : q[7:0];
        // Conditionally update upper byte
        q[15:8] <= byteena[1] ? d[15:8] : q[15:8];
    end
    // If clk_en is low, hold current state, minimizing toggling
end

endmodule