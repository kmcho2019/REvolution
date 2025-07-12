module TopModule (
    input             clk,
    input             load,
    input      [1:0]  ena,
    input      [99:0] data,
    output reg [99:0] q
);

    // Split q into two halves for hierarchical rotation
    reg [49:0] q_hi; // bits [99:50]
    reg [49:0] q_lo; // bits [49:0]

    wire [49:0] data_hi = data[99:50];
    wire [49:0] data_lo = data[49:0];

    // Rotate left a 50-bit vector by 1
    function [49:0] rotate_left_50(input [49:0] val);
        rotate_left_50 = {val[48:0], val[49]};
    endfunction

    // Rotate right a 50-bit vector by 1
    function [49:0] rotate_right_50(input [49:0] val);
        rotate_right_50 = {val[0], val[49:1]};
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Synchronously load data into both halves
            q_hi <= data_hi;
            q_lo <= data_lo;
        end else if (ena == 2'b10) begin
            // Rotate left by 1:
            // Step 1: rotate each half left by 1
            // Step 2: swap the bits between halves to complete 100-bit rotation

            // Store rotated halves
            reg [49:0] rot_hi, rot_lo;
            rot_hi = rotate_left_50(q_hi);
            rot_lo = rotate_left_50(q_lo);

            // Bits that rotate around between halves:
            // MSB of q_lo (bit 49) moves to LSB of q_hi (bit 0)
            // MSB of q_hi (bit 49) moves to LSB of q_lo (bit 0)

            q_hi <= {rot_hi[48:0], q_lo[49]};
            q_lo <= {rot_lo[48:0], q_hi[49]};

        end else if (ena == 2'b01) begin
            // Rotate right by 1:
            // Step 1: rotate each half right by 1
            // Step 2: swap bits between halves accordingly

            reg [49:0] rot_hi, rot_lo;
            rot_hi = rotate_right_50(q_hi);
            rot_lo = rotate_right_50(q_lo);

            // Bits that rotate around between halves:
            // LSB of q_hi (bit 0) moves to MSB of q_lo (bit 49)
            // LSB of q_lo (bit 0) moves to MSB of q_hi (bit 49)

            q_hi <= {q_lo[0], rot_hi[49:1]};
            q_lo <= {q_hi[0], rot_lo[49:1]};
        end
        // else (ena == 00 or 11): no rotation, hold state (no update)
        // Note: no else clause means q_hi, q_lo retain values, minimizing toggling
    end

    // Concatenate halves to output q
    always @(*) begin
        q = {q_hi, q_lo};
    end

endmodule