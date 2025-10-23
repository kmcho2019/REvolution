module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    // Helper function: get cell value or 0 if out of range
    function automatic bit cell_at(input [511:0] arr, input integer idx);
        if (idx < 0 || idx > 511)
            cell_at = 1'b0;
        else
            cell_at = arr[idx];
    endfunction

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            wire left = cell_at(q, i + 1);
            wire center = q[i];
            wire right = cell_at(q, i - 1);
            // Apply Rule 110:
            // Table states in order:
            // L C R | next
            // 1 1 1 -> 0
            // 1 1 0 -> 1
            // 1 0 1 -> 1
            // 1 0 0 -> 0
            // 0 1 1 -> 1
            // 0 1 0 -> 1
            // 0 0 1 -> 1
            // 0 0 0 -> 0
            // Using truth table, the formula can be expressed as:
            // next = ( (~left & center) | (center ^ right) );
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule