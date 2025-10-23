module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        case (ena)
            2'b01: state <= {state[0], state[99:1]}; // rotate right
            2'b10: state <= {state[98:0], state[99]}; // rotate left
            default: state <= state; // do not rotate
        endcase
    end
end

assign q = state;

endmodule