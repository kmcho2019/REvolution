module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Clock gating for enable signal
wire gated_clk;
assign gated_clk = clk & (load | ena | areset);

always @(posedge gated_clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end
    else if (load) begin
        q <= data;
    end
    else if (ena) begin
        q <= q >> 1;  // Right shift with zero fill
    end
end

endmodule