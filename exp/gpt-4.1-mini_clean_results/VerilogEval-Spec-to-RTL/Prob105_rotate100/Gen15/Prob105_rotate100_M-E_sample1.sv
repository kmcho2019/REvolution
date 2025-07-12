module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    integer i;
    reg [99:0] rotated;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena == 2'b10) begin
            // Rotate left by 1
            for (i = 0; i < 100; i = i + 1) begin
                rotated[i] = q[(i + 1) % 100];
            end
            q <= rotated;
        end else if (ena == 2'b01) begin
            // Rotate right by 1
            for (i = 0; i < 100; i = i + 1) begin
                rotated[i] = q[(i + 99) % 100]; // (i - 1) mod 100
            end
            q <= rotated;
        end else begin
            q <= q;
        end
    end

endmodule