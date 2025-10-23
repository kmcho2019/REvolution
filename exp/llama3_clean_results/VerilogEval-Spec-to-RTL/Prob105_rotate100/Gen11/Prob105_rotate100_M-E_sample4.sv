module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] ring_counter;

always @(posedge clk) begin
    if (load) begin
        ring_counter <= data;
    end else begin
        case (ena)
            2'b01: ring_counter <= {ring_counter[0], ring_counter[99:1]}; // Rotate right
            2'b10: ring_counter <= {ring_counter[98:0], ring_counter[99]}; // Rotate left
            default: ring_counter <= ring_counter; // No rotation
        endcase
    end
end

assign q = ring_counter;

endmodule