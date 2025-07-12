module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] current_state;

// Always block for loading the shift register
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end
end

// Always block for rotating the shift register
always @(posedge clk) begin
    case (ena)
        2'b01: // rotate right
            current_state <= {current_state[0], current_state[99:1]};
        2'b10: // rotate left
            current_state <= {current_state[98:0], current_state[99]};
        default: // do nothing for ena == 2'b00 or 2'b11
            current_state <= current_state;
    endcase
end

assign q = current_state;

endmodule