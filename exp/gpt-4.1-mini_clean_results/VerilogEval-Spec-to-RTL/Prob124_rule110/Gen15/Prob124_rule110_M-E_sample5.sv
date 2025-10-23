module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Next state register (builds the next generation iteratively)
    reg [511:0] next_q;

    // Index to iterate over cells for next state computation
    reg [8:0] idx; // 9 bits to count from 0 to 511

    // State machine: 
    // When load=1, load data directly into q and reset idx to 0.
    // When load=0, compute next_q[idx] each clock cycle based on q's neighbors.
    // After idx reaches 511, transfer next_q to q and reset idx.

    // Compute neighbors with zero boundary assumption
    // neighbors: left = q[idx+1] if idx<511 else 0
    //            center = q[idx]
    //            right = q[idx-1] if idx>0 else 0

    wire left;
    wire center;
    wire right;

    assign center = q[idx];
    assign left = (idx < 511) ? q[idx + 1] : 1'b0;
    assign right = (idx > 0) ? q[idx - 1] : 1'b0;

    // Rule 110 logic: next_center = (~left & center) | (center ^ right);
    wire next_cell = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q <= 0;
            idx <= 0;
        end else begin
            // Update next_q bit at idx position
            next_q[idx] <= next_cell;

            if (idx == 9'd511) begin
                // Finished computing entire next state
                q <= next_q;   // update q with new generation
                idx <= 0;      // reset index for next generation
            end else begin
                idx <= idx + 1'b1; // increment index to compute next cell
            end
        end
    end

endmodule