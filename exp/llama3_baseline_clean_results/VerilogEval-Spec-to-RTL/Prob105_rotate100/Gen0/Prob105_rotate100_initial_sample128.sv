module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] rotator;

always @(posedge clk) begin
    if (load) begin
        rotator <= data;
    end else begin
        case (ena)
            2'b01: rotator <= {rotator[0], rotator[99:1]}; // rotate right
            2'b10: rotator <= {rotator[98:0], rotator[99]}; // rotate left
            default: rotator <= rotator; // do not rotate
        endcase
    end
end

assign q = rotator;

endmodule