module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;
    integer i;

    always @* begin
        if (load) begin
            // Load data directly on load
            next_q = data;
        end else if (ena == 2'b01) begin
            // Rotate right by one bit: next_q[i] = q[(i+1)%100]
            for (i = 0; i < 99; i = i + 1) begin
                next_q[i] = q[i + 1];
            end
            next_q[99] = q[0];
        end else if (ena == 2'b10) begin
            // Rotate left by one bit: next_q[i] = q[(i-1+100)%100]
            next_q[0] = q[99];
            for (i = 1; i < 100; i = i + 1) begin
                next_q[i] = q[i - 1];
            end
        end else begin
            // No rotation, hold current state to prevent toggling
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule