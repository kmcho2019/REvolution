module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else if (ena == 2'b01) begin // Rotate right
        current_state <= {current_state[0], current_state[99:1]};
    end else if (ena == 2'b10) begin // Rotate left
        current_state <= {current_state[98:0], current_state[99]};
    end else if (ena == 2'b11 || ena == 2'b00) begin // No rotation
        current_state <= current_state;
    end
end

assign q = current_state;

endmodule