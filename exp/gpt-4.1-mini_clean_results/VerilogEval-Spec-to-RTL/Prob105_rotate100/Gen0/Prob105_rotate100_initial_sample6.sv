module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: // rotate right by one
                    q <= {q[0], q[99:1]};
                2'b10: // rotate left by one
                    q <= {q[98:0], q[99]};
                default: // 2'b00 or 2'b11 do not rotate
                    q <= q;
            endcase
        end
    end

endmodule