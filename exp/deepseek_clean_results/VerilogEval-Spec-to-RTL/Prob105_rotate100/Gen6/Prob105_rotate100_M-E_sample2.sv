module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Rotation control signals
wire rotate_left = (ena == 2'b10);
wire rotate_right = (ena == 2'b01);
wire rotate_enable = rotate_left | rotate_right;

// Next state logic
reg [99:0] next_q;

always @(*) begin
    if (load) begin
        next_q = data;
    end else if (rotate_enable) begin
        // Barrel rotation implementation
        for (integer i = 0; i < 100; i = i + 1) begin
            case ({rotate_left, rotate_right})
                2'b10: next_q[i] = q[(i + 1) % 100];  // Left rotation
                2'b01: next_q[i] = q[(i + 99) % 100]; // Right rotation
                default: next_q[i] = q[i];            // No rotation
            endcase
        end
    end else begin
        next_q = q;
    end
end

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule