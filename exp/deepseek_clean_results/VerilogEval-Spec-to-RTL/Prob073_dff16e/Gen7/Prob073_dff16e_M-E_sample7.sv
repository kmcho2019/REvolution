module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Clock gating cells for each byte segment
wire upper_byte_clk;
wire lower_byte_clk;

// Clock gating logic
assign upper_byte_clk = byteena[1] ? clk : 1'b0;
assign lower_byte_clk = byteena[0] ? clk : 1'b0;

// Upper byte (15:8) with gated clock
always @(posedge upper_byte_clk or negedge resetn) begin
    if (!resetn) begin
        q[15:8] <= 8'b0;
    end else begin
        q[15:8] <= d[15:8];
    end
end

// Lower byte (7:0) with gated clock
always @(posedge lower_byte_clk or negedge resetn) begin
    if (!resetn) begin
        q[7:0] <= 8'b0;
    end else begin
        q[7:0] <= d[7:0];
    end
end

endmodule