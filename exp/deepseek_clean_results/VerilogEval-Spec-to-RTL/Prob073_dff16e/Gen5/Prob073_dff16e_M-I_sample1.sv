module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Clock gating signals
wire upper_byte_clk_en = byteena[1] | (|q[15:8]);
wire lower_byte_clk_en = byteena[0] | (|q[7:0]);

// Sequential logic with synchronous reset and byte enables
always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        if (upper_byte_clk_en) begin
            q[15:8] <= byteena[1] ? d[15:8] : q[15:8];
        end
        if (lower_byte_clk_en) begin
            q[7:0] <= byteena[0] ? d[7:0] : q[7:0];
        end
    end
end

endmodule