module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // State machine:
    // When load=1, load q with data immediately.
    // Otherwise, update one cell per clock:
    //   For each cell i from 0 to 511:
    //     Compute next_state[i] from q[i+1], q[i], q[i-1] (out of range = 0)
    //     Store next_state[i] in a temp register next_q
    // After processing all 512 cells (counter wraps), copy next_q to q.

    reg [511:0] next_q;      // building next state serially
    reg [8:0] update_idx;    // counts 0 to 511, 9 bits enough
    reg updating;            // flag indicating we're updating (one cell per cycle)

    // Function to get bit safely with boundary conditions
    function automatic bit get_bit(input [511:0] arr, input integer idx);
        if (idx < 0 || idx > 511)
            get_bit = 1'b0;
        else
            get_bit = arr[idx];
    endfunction

    // Compute next state of a single cell according to Rule 110 logic
    function automatic bit rule110_cell(
        input bit left,
        input bit center,
        input bit right
    );
        // Rule110 next state = (~left & center) | (center ^ right)
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Load entire state immediately, reset update process
            q <= data;
            next_q <= 0;
            update_idx <= 0;
            updating <= 0;
        end else begin
            if (!updating) begin
                // Start update cycle
                updating <= 1;
                update_idx <= 0;
                next_q <= 0;
            end else begin
                // Compute next state bit for cell update_idx
                bit left = get_bit(q, update_idx + 1);
                bit center = get_bit(q, update_idx);
                bit right = get_bit(q, update_idx - 1);
                bit nxt_bit = rule110_cell(left, center, right);

                next_q[update_idx] <= nxt_bit;

                if (update_idx == 9'd511) begin
                    // Completed full update, copy next_q to q
                    q <= next_q;
                    updating <= 0;
                end else begin
                    update_idx <= update_idx + 1;
                end
            end
        end
    end

endmodule