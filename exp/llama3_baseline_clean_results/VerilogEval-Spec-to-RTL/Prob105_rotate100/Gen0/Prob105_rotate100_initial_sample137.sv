module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] reg_q;

always @(posedge clk) begin
    if (load) begin
        reg_q <= data;
    end else begin
        case (ena)
            2'b01: reg_q <= {reg_q[0], reg_q[99:1]}; // rotate right
            2'b10: reg_q <= {reg_q[98:0], reg_q[99]}; // rotate left
            default: reg_q <= reg_q; // no rotation
        endcase
    end
end

assign q = reg_q;

endmodule