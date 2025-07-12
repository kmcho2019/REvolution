module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Function to compute the next state of the entire 512-cell array
    function [511:0] rule110_next_state(input [511:0] curr_state);
        integer idx;
        reg left, center, right;
        reg [513:0] ext_state; // zero-padded state for boundaries
        reg [511:0] next_state;

        begin
            // Pad current state with zeros at both ends to handle boundaries
            ext_state = {1'b0, curr_state, 1'b0};

            for (idx = 0; idx < 512; idx = idx + 1) begin
                left   = ext_state[idx + 2];
                center = ext_state[idx + 1];
                right  = ext_state[idx];

                // Apply Rule 110 logic
                next_state[idx] = (~left & center) | (center ^ right);
            end

            rule110_next_state = next_state;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= rule110_next_state(q);
        end
    end

endmodule