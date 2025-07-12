module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] rot_state;

always @(posedge clk) begin
    if (load) begin
        rot_state <= data;
    end else if (ena == 2'b01) begin // rotate right
        rot_state <= {rot_state[0], rot_state[99:1]};
    end else if (ena == 2'b10) begin // rotate left
        rot_state <= {rot_state[98:0], rot_state[99]};
    end else begin // no rotation
        rot_state <= rot_state;
    end
end

assign q = rot_state;

endmodule