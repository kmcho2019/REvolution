module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;
    integer i;

    always @* begin
        // Default: hold current value
        next_q = q;

        if (load) begin
            // Load takes priority
            next_q = data;
        end else if (ena == 2'b10) begin
            // Rotate left by 1: bit i gets q[i+1], MSB gets q[0]
            for (i = 0; i < 99; i = i + 1) begin
                next_q[i] = q[i+1];
            end
            next_q[99] = q[0];
        end else if (ena == 2'b01) begin
            // Rotate right by 1: bit i gets q[i-1], LSB gets q[99]
            next_q[0] = q[99];
            for (i = 1; i < 100; i = i + 1) begin
                next_q[i] = q[i-1];
            end
        end
        // else keep q unchanged (next_q = q) with no redundant assignment
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule