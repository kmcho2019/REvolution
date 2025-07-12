module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Shift register and control logic
    reg [2:0] window;  // Current 3-bit window (left, center, right)
    reg [8:0] counter;  // 512 steps (9 bits)
    reg computing;
    
    // Precomputed Rule 110 results for all 8 possible 3-bit combinations
    wire [7:0] rule110_lut = 8'b01110100; // LUT for patterns 000 to 111
    
    // State machine
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            counter <= 0;
            computing <= 0;
        end else begin
            if (!computing) begin
                // Start new computation cycle
                computing <= 1;
                counter <= 0;
                window <= {q[510], q[511], 1'b0}; // Initialize with q[511] as center
            end else begin
                if (counter < 511) begin
                    // Shift window and compute next state
                    window <= {q[counter], window[2:1]};
                    q[counter] <= rule110_lut[{window[2], window[1], window[0]}];
                    counter <= counter + 1;
                end else begin
                    // Final computation for last bit
                    window <= {1'b0, window[2:1]}; // Right boundary is 0
                    q[511] <= rule110_lut[{window[2], window[1], 1'b0}];
                    computing <= 0;
                end
            end
        end
    end

endmodule