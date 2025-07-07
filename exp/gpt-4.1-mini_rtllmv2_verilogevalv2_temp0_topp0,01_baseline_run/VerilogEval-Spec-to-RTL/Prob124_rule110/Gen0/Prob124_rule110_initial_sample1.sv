module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of a cell given left, center, right bits
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        begin
            // According to the table:
            // left center right | next
            // 1    1      1     | 0
            // 1    1      0     | 1
            // 1    0      1     | 1
            // 1    0      0     | 0
            // 0    1      1     | 1
            // 0    1      0     | 1
            // 0    0      1     | 1
            // 0    0      0     | 0

            if (left == 1'b1 && center == 1'b1 && right == 1'b1) rule110_cell = 1'b0;
            else if (left == 1'b1 && center == 1'b1 && right == 1'b0) rule110_cell = 1'b1;
            else if (left == 1'b1 && center == 1'b0 && right == 1'b1) rule110_cell = 1'b1;
            else if (left == 1'b1 && center == 1'b0 && right == 1'b0) rule110_cell = 1'b0;
            else if (left == 1'b0 && center == 1'b1 && right == 1'b1) rule110_cell = 1'b1;
            else if (left == 1'b0 && center == 1'b1 && right == 1'b0) rule110_cell = 1'b1;
            else if (left == 1'b0 && center == 1'b0 && right == 1'b1) rule110_cell = 1'b1;
            else /* 0 0 0 */ rule110_cell = 1'b0;
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            for (i = 0; i < 512; i = i + 1) begin
                bit left, center, right;
                // left neighbor: q[i+1], zero if i=511
                if (i == 511)
                    left = 1'b0;
                else
                    left = q[i+1];
                // center: q[i]
                center = q[i];
                // right neighbor: q[i-1], zero if i=0
                if (i == 0)
                    right = 1'b0;
                else
                    right = q[i-1];

                next_q[i] = rule110_cell(left, center, right);
            end
            q <= next_q;
        end
    end

endmodule