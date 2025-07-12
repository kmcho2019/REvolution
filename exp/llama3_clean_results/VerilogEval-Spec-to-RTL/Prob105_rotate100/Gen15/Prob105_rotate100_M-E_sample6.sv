module BarrelShifter(
    input [99:0] data,
    input [1:0]  direction, // 2'b01 for right, 2'b10 for left
    output [99:0] result
);

wire [99:0] right_rotate = {data[0], data[99:1]};
wire [99:0] left_rotate = {data[98:0], data[99]};

always @(data or direction) begin
    case (direction)
        2'b01: result = right_rotate;
        2'b10: result = left_rotate;
        default: result = data;
    endcase
end

endmodule

module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]    data,
    output reg [99:0]   q
);

BarrelShifter barrel_shifter(
   .data(data),
   .direction(ena),
   .result(q)
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        if (ena == 2'b01 || ena == 2'b10) begin
            q <= {q[0], q[99:1]}; // Right rotation
        end else if (ena == 2'b10) begin
            q <= {q[98:0], q[99]}; // Left rotation
        end else begin
            q <= q; // No rotation
        end
    end
end

endmodule