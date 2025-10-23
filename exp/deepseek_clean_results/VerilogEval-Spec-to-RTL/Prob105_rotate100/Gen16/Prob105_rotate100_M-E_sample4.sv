module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [49:0] upper, lower;
wire swap = (ena == 2'b01) ^ (ena == 2'b10); // XOR to detect any rotation
wire dir = (ena == 2'b10); // 1 for left, 0 for right

always @(posedge clk) begin
    if (load) begin
        upper <= data[99:50];
        lower <= data[49:0];
    end
    else if (swap) begin
        if (dir) begin // left rotation
            upper <= {upper[48:0], lower[49]};
            lower <= {lower[48:0], upper[49]};
        end
        else begin // right rotation
            upper <= {lower[0], upper[49:1]};
            lower <= {upper[0], lower[49:1]};
        end
    end
end

assign q = {upper, lower};

endmodule