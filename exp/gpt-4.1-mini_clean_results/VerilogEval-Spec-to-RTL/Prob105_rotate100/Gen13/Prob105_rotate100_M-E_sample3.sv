module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    integer i;

    always @(posedge clk) begin
        if (load) begin
            // Synchronous load
            q <= data;
        end else begin
            case (ena)
                2'b01: begin
                    // Rotate right by one bit
                    // q[0] gets q[99], q[1] gets q[0], ..., q[99] gets q[98]
                    q[0] <= q[99];
                    for (i = 1; i < 100; i = i + 1) begin
                        q[i] <= q[i-1];
                    end
                end
                2'b10: begin
                    // Rotate left by one bit
                    // q[99] gets q[0], q[0] gets q[1], ..., q[98] gets q[99]
                    q[99] <= q[0];
                    for (i = 0; i < 99; i = i + 1) begin
                        q[i] <= q[i+1];
                    end
                end
                default: begin
                    // No rotation
                    q <= q;
                end
            endcase
        end
    end

endmodule