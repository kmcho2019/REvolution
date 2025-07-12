module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal registers:
    reg [511:0] shift_reg;      // Holds current state, accessed for neighbors
    reg [511:0] next_state_reg; // Accumulates next state bits serially
    reg [8:0] cell_idx;         // 9-bit counter to index cells 0..511
    reg updating;               // Indicates update in progress (not load)

    // Function to compute Rule 110 next state for a cell from neighbors
    function automatic bit rule110_cell(
        input bit left,
        input bit center,
        input bit right
    );
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    // Extract neighbor bits with zero boundary padding
    wire left, center, right;
    assign center = shift_reg[cell_idx];
    assign left = (cell_idx == 9'd511) ? 1'b0 : shift_reg[cell_idx + 1];
    assign right = (cell_idx == 9'd0) ? 1'b0 : shift_reg[cell_idx - 1];

    // Next state for current indexed cell
    wire cell_next = rule110_cell(left, center, right);

    always @(posedge clk) begin
        if (load) begin
            // Load input data and reset update process
            shift_reg <= data;
            next_state_reg <= 512'b0;
            cell_idx <= 0;
            updating <= 1'b0;
            q <= data;  // output reflects loaded data immediately
        end else begin
            if (!updating) begin
                // Start a new update cycle
                updating <= 1'b1;
                cell_idx <= 0;
                next_state_reg <= 512'b0;
            end else begin
                // Compute and accumulate next state bit serially
                // Store next state bit in bit position cell_idx of next_state_reg
                next_state_reg[cell_idx] <= cell_next;

                if (cell_idx == 9'd511) begin
                    // Completed one full update, commit new state
                    shift_reg <= next_state_reg;
                    q <= next_state_reg;
                    updating <= 1'b0;   // Ready for next load or update
                    cell_idx <= 0;
                end else begin
                    cell_idx <= cell_idx + 1;
                end
            end
        end
    end

endmodule