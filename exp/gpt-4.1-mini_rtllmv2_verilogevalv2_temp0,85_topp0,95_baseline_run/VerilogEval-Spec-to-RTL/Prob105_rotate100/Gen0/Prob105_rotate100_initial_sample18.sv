module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [1:0]  ena,
    input  wire [99:0] data,
    output reg  [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: // rotate right by 1
                q <= {q[0], q[99:1]};
            2'b10: // rotate left by 1
                q <= {q[98:0], q[99]};
            default: // no rotation
                q <= q;
        endcase
    end
end

endmodule