module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;
    integer i;

    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with boundary conditions
            reg left, center, right;
            center = q[i];
            if (i == 511)
                left = 1'b0;
            else
                left = q[i + 1];
            if (i == 0)
                right = 1'b0;
            else
                right = q[i - 1];

            // Rule 110 next state
            next_state[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule