module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // State registers
    reg [511:0] next_q;
    reg [8:0]   idx;          // 0..511 index counter (9 bits to cover 512)
    reg         processing;    // Indicates when we're processing a generation step

    // Sliding window for neighbors: [left, center, right]
    // We'll shift bits in from q to get the neighborhood
    reg [2:0] window;

    // Control signals for the serial update
    // At the start of processing, window is initialized with zeros (for left boundary)
    // Then bits are shifted in from q one at a time each cycle

    // Rule 110 function (pure combinational)
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Load the entire state at once, reset processing state
            q          <= data;
            next_q     <= 0;
            idx        <= 0;
            processing <= 1'b1;   // Start processing next generation on next cycles
            window     <= 3'b000; // Initialize sliding window with zeros (left boundary)
        end else if (processing) begin
            // Sliding window shifting logic
            // Build neighborhood for current idx:

            // For each idx from 0 to 511, neighbors are:
            // left   = q[idx+1] if idx < 511 else 0
            // center = q[idx]
            // right  = q[idx-1] if idx > 0 else 0

            // But since we process serially, we simulate this by shifting window:
            // We'll shift bits from q as "center" moving through idx 0..511
            // We'll reconstruct left and right by maintaining window

            // For idx=0:
            // left  = q[1], center = q[0], right = 0
            // For idx>0:
            // left  = previous center
            // center= current bit
            // right = previous right bit (or q[idx-1])

            // We implement this by shifting bits from q starting at idx=0:
            // On cycle idx:
            // - read q[idx+1] into left (or 0 if idx=511)
            // - read q[idx] into center
            // - right = previous center (i.e., window[1]) or 0 when idx=0

            bit left_bit, center_bit, right_bit;
            if (idx < 511)
                left_bit = q[idx+1];
            else
                left_bit = 1'b0;

            center_bit = q[idx];

            if (idx == 0)
                right_bit = 1'b0;
            else
                right_bit = window[1]; // previous center_bit

            // Compute next state for current cell
            bit next_state = rule110_cell(left_bit, center_bit, right_bit);

            // Shift next_q left, insert next_state at LSB (build next_q from LSB upwards)
            next_q <= {next_q[510:0], next_state};

            // Update sliding window: window shifts left with center_bit as new "center"
            // window = {left, center, right} per neighborhood, but for next idx
            // We'll update window for next iteration:
            // window[2] <= left_bit
            // window[1] <= center_bit
            // window[0] <= right_bit (previous center)
            // For ease, just store center_bit at window[1] and left_bit at window[2]
            // right_bit is previous window[1], already known

            window[2] <= left_bit;
            window[1] <= center_bit;
            window[0] <= right_bit;

            // Advance index
            if (idx == 511) begin
                // Finished processing all bits
                q          <= next_q;
                next_q     <= 0;
                idx        <= 0;
                processing <= 1'b1; // Continue processing next generation automatically
                window     <= 3'b000; // Reset window for next iteration
            end else begin
                idx <= idx + 1;
            end

        end else begin
            // Not processing and not loading: idle state, keep q steady
            // Optionally could start processing automatically here if desired
            processing <= 1'b1; // Start processing next generation by default
            idx        <= 0;
            window     <= 3'b000;
            next_q     <= 0;
        end
    end

endmodule