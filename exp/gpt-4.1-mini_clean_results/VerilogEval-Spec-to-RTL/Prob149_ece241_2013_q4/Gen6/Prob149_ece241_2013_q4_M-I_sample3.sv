module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding as localparams (2-bit values)
    localparam [1:0] BELOW    = 2'd0;
    localparam [1:0] BTWN_10  = 2'd1;  // Between s[1] and s[0]
    localparam [1:0] BTWN_21  = 2'd2;  // Between s[2] and s[1]
    localparam [1:0] ABOVE    = 2'd3;

    // Function to decode water level based on sensors
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            if (sensors[2])
                decode_level = ABOVE;
            else if (sensors[1])
                decode_level = BTWN_21;
            else if (sensors[0])
                decode_level = BTWN_10;
            else
                decode_level = BELOW;
        end
    endfunction

    reg [1:0] curr_level, prev_level;
    wire [1:0] sensor_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            // Reset levels to BELOW (lowest)
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            if (sensor_level != curr_level) begin
                prev_level <= curr_level;
                curr_level <= sensor_level;
            end
            // else keep levels as is
        end
    end

    // Nominal flow rates based on current water level
    wire fr0_nominal = (curr_level <= BTWN_21);
    wire fr1_nominal = (curr_level <= BTWN_10);
    wire fr2_nominal = (curr_level == BELOW);

    // Supplemental flow valve asserted if water level increased since last level
    wire dfr_nominal = (curr_level > prev_level);

    // Outputs directly driven by nominal signals; synchronous reset handled by reg init
    assign fr0 = fr0_nominal;
    assign fr1 = fr1_nominal;
    assign fr2 = fr2_nominal;
    assign dfr = dfr_nominal;

endmodule