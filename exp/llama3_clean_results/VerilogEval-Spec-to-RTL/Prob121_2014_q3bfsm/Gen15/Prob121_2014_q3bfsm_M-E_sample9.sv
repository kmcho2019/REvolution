module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// LUT (ROM) for next state and output
always @(*) begin
    case ({y, x})
        5'b00000: begin next_y = 3'b000; z = 1'b0; end
        5'b00001: begin next_y = 3'b001; z = 1'b0; end
        5'b00100: begin next_y = 3'b001; z = 1'b0; end
        5'b00101: begin next_y = 3'b100; z = 1'b0; end
        5'b01000: begin next_y = 3'b010; z = 1'b0; end
        5'b01001: begin next_y = 3'b001; z = 1'b0; end
        5'b01100: begin next_y = 3'b001; z = 1'b1; end
        5'b01101: begin next_y = 3'b010; z = 1'b1; end
        5'b10000: begin next_y = 3'b011; z = 1'b1; end
        5'b10001: begin next_y = 3'b100; z = 1'b1; end
        default: begin next_y = 3'b000; z = 1'b0; end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule