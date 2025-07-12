module TopModule (
    input  clk,
    input  load,
    input  [1:0] ena,
    input  [99:0] data,
    output [99:0] q
);

reg [99:0] rotator;

always @(posedge clk) begin
    if (load) begin
        rotator <= data;
    end else begin
        case (ena)
            2'b01: // rotate right by one bit
                rotator <= {rotator[0], rotator[99:1]};
            2'b10: // rotate left by one bit
                rotator <= {rotator[98:0], rotator[99]};
            default: // do not rotate
                rotator <= rotator;
        endcase
    end
end

assign q = rotator;

endmodule