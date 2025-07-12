module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire update = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena == 2'b01) begin
            q <= {q[0], q[99:1]};    // Rotate right by 1
        end else if (ena == 2'b10) begin
            q <= {q[98:0], q[99]};   // Rotate left by 1
        end
        // else hold q, no assignment (register holds value, no toggling)
    end

endmodule