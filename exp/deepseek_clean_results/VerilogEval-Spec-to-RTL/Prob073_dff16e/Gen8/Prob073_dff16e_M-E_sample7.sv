module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Clock gating cells for each byte lane
wire upper_byte_clk;
wire lower_byte_clk;

clk_gate upper_gate (
    .clk_in(clk),
    .enable(byteena[1]),
    .clk_out(upper_byte_clk)
);

clk_gate lower_gate (
    .clk_in(clk),
    .enable(byteena[0]),
    .clk_out(lower_byte_clk)
);

// Upper byte (bits 15:8)
always @(posedge upper_byte_clk or negedge resetn) begin
    if (!resetn) begin
        q[15:8] <= 8'b0;
    end else begin
        q[15:8] <= d[15:8];
    end
end

// Lower byte (bits 7:0)
always @(posedge lower_byte_clk or negedge resetn) begin
    if (!resetn) begin
        q[7:0] <= 8'b0;
    end else begin
        q[7:0] <= d[7:0];
    end
end

endmodule

// Simple clock gating cell
module clk_gate (
    input clk_in,
    input enable,
    output clk_out
);
    reg en_latched;
    always @(negedge clk_in) begin
        en_latched <= enable;
    end
    assign clk_out = clk_in & en_latched;
endmodule