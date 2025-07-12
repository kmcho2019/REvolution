module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = (ena == 2'b01) || (ena == 2'b10);
wire gated_clk = clk & (load | rotate_en);

always @(posedge gated_clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: begin // Right rotate using barrel shifter
                q <= {q[0], q[99:1]};
            end
            2'b10: begin // Left rotate using barrel shifter
                q <= {q[98:0], q[99]};
            end
            default: q <= q;
        endcase
    end
end

endmodule