module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] current_state;

always @(posedge clk) begin
    case ({load, ena})
        3'b100: current_state <= data; // load
        3'b010: current_state <= {current_state[0], current_state[99:1]}; // rotate right
        3'b110: current_state <= {current_state[98:0], current_state[99]}; // rotate left
        default: current_state <= current_state; // do nothing
    endcase
end

assign q = current_state;

endmodule