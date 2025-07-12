module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [8:0] pos; // 0 to 511 index for cell update
    reg [511:0] next_q;

    // Compute Rule 110 next state for one cell given its neighbors
    function automatic bit rule110_cell(
        input bit left,
        input bit center,
        input bit right
    );
        // next_state = (~left & center) | (center ^ right)
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    // Sequential logic to update state
    always @(posedge clk) begin
        if (load) begin
            // Load entire state and reset position
            q <= data;
            next_q <= data;
            pos <= 0;
        end else begin
            // Update one cell at position pos per clock
            // Extract neighbors from current state q
            // Left = q[pos+1] or 0 if pos == 511
            // Center = q[pos]
            // Right = q[pos-1] or 0 if pos == 0
            bit left_cell = (pos == 9'd511) ? 1'b0 : q[pos + 1];
            bit center_cell = q[pos];
            bit right_cell = (pos == 9'd0) ? 1'b0 : q[pos - 1];

            bit next_state = rule110_cell(left_cell, center_cell, right_cell);

            next_q[pos] <= next_state;

            // Only update q after one full pass of 512 updates
            // So update q when pos == 511 (end of cycle)
            if (pos == 9'd511) begin
                q <= next_q;
                pos <= 0;
            end else begin
                pos <= pos + 1;
            end
        end
    end

endmodule