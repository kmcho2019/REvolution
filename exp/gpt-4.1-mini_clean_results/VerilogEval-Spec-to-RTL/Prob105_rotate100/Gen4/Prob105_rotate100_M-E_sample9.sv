module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire [99:0] rotated;

    // Combinational rotation logic based on ena
    assign rotated = (ena == 2'b01) ? {q[0], q[99:1]} :   // Rotate right by 1
                     (ena == 2'b10) ? {q[98:0], q[99]} :  // Rotate left by 1
                                      q;                   // No rotation

    always @(posedge clk) begin
        if (load) begin
            // Synchronous load of input data
            q <= data;
        end else begin
            // Update q with rotated value or keep unchanged if no rotation
            q <= rotated;
        end
    end

endmodule