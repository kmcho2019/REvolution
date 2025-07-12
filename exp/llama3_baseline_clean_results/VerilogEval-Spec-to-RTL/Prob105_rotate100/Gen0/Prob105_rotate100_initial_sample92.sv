module TopModule(
    input  clk,
    input  load,
    input  [1:0] ena,
    input  [99:0] data,
    output [99:0] q
);

reg [99:0] rot_data;

always @(posedge clk) begin
    if (load) begin
        rot_data <= data;
    end else begin
        case (ena)
            2'b01: begin // rotate right by one bit
                rot_data <= {rot_data[0], rot_data[99:1]};
            end
            2'b10: begin // rotate left by one bit
                rot_data <= {rot_data[98:0], rot_data[99]};
            end
            default: begin // do not rotate
                rot_data <= rot_data;
            end
        endcase
    end
end

assign q = rot_data;

endmodule