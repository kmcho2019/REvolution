module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// LUT for next state and output
always @ (*) begin
    case ({x, y})
        4'b0_000: begin next_state = 3'b000; z = 1'b0; end
        4'b0_001: begin next_state = 3'b001; z = 1'b0; end
        4'b0_010: begin next_state = 3'b010; z = 1'b0; end
        4'b0_011: begin next_state = 3'b001; z = 1'b1; end
        4'b0_100: begin next_state = 3'b011; z = 1'b1; end
        4'b1_000: begin next_state = 3'b001; z = 1'b0; end
        4'b1_001: begin next_state = 3'b100; z = 1'b0; end
        4'b1_010: begin next_state = 3'b001; z = 1'b0; end
        4'b1_011: begin next_state = 3'b010; z = 1'b1; end
        4'b1_100: begin next_state = 3'b100; z = 1'b1; end
        default: begin next_state = 3'b000; z = 1'b0; end
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];

// Initialize state
initial begin
    current_state = 3'b000;
end

endmodule