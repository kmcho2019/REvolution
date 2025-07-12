module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_enable = |ena;  // High when any rotation is enabled
wire clock_enable = load || rotate_enable;

always @(posedge clk) begin
    if (clock_enable) begin
        if (load) begin
            q <= data;
        end
        else begin
            if (ena[0]) begin      // Right rotate
                q <= {q[0], q[99:1]};
            end
            else if (ena[1]) begin // Left rotate
                q <= {q[98:0], q[99]};
            end
        end
    end
end

endmodule