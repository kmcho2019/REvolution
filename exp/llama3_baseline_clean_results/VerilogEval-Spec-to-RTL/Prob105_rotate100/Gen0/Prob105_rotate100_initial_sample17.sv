module TopModule (
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
            2'b01: begin
                rotator <= {rotator[0], rotator[99:1]};
            end
            2'b10: begin
                rotator <= {rotator[98:0], rotator[99]};
            end
            default: begin
                rotator <= rotator;
            end
        endcase
    end
end

assign q = rotator;

endmodule