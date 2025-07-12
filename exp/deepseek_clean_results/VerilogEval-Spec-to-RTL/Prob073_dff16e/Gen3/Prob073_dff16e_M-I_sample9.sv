module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

wire clk_enable = |byteena;  // Clock gating when either byte is enabled
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk or negedge resetn) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Combined enable logic for better timing
        q <= {byteena[1] ? d[15:8] : q[15:8],
              byteena[0] ? d[7:0] : q[7:0]};
    end
end

endmodule