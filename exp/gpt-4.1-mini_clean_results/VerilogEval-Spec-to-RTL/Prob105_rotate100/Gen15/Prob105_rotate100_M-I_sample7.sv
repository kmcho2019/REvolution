module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire update_enable = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena == 2'b10) begin
            // Rotate left split into two 50-bit parts
            q <= {q[48:0], q[99], q[97:49], q[98]};
        end else if (ena == 2'b01) begin
            // Rotate right split into two 50-bit parts
            q <= {q[50], q[99:51], q[0], q[47:1]};
        end
        // else hold q
    end

endmodule