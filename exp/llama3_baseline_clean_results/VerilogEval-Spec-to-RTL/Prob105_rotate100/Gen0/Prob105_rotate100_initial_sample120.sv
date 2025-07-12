module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] current_state;

always @(posedge clk) begin
    if(load) begin
        current_state <= data;
    end else begin
        case(ena)
            2'b01: current_state <= {current_state[0], current_state[99:1]};
            2'b10: current_state <= {current_state[98:0], current_state[99]};
            default: current_state <= current_state;
        endcase
    end
end

assign q = current_state;

endmodule