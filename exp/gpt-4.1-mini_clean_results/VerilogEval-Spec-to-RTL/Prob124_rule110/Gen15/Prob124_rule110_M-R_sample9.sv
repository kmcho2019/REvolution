module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;
    integer i;

    always @* begin
        // Compute next state combinationally
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with zero boundary
            // left neighbor = q[i+1] if valid else 0
            // right neighbor = q[i-1] if valid else 0
            // center = q[i]
            reg left, center, right;
            left = (i == 511) ? 1'b0 : q[i + 1];
            center = q[i];
            right = (i == 0) ? 1'b0 : q[i - 1];

            // Rule 110 logic: next = (~left & center) | (center ^ right)
            next_state[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule