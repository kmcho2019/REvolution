module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

// Generate enables per byte
wire lower_byte_en = byteena[0];
wire upper_byte_en = byteena[1];

// Prepare next data for each byte with mux selecting between current q and input d
wire [7:0] next_lower = lower_byte_en ? d[7:0] : q[7:0];
wire [7:0] next_upper = upper_byte_en ? d[15:8] : q[15:8];

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update only enabled bytes; retain others
        // This fine-grained conditional assignment lets synthesis map to clock enables or gating
        q[7:0]   <= next_lower;
        q[15:8]  <= next_upper;
    end
end

endmodule