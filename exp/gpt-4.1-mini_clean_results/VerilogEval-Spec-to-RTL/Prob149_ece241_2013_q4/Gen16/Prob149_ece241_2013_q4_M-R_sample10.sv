module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water levels encoding
    localparam BELOW    = 2'd0; // No sensors asserted: s=3'b000
    localparam BETWEEN0 = 2'd1; // Only lowest sensor asserted: s=3'b001
    localparam BETWEEN1 = 2'd2; // Lowest and middle sensors asserted: s=3'b011
    localparam ABOVE    = 2'd3; // All sensors asserted: s=3'b111

    // Decode sensor pattern exactly
    wire is_above    = (s == 3'b111);
    wire is_between1 = (s == 3'b011);
    wire is_between0 = (s == 3'b001);
    wire is_below    = (s == 3'b000);

    // Default to BELOW for any unexpected pattern
    wire [1:0] decoded_level = is_above    ? ABOVE    :
                              is_between1 ? BETWEEN1 :
                              is_between0 ? BETWEEN0 :
                              is_below    ? BELOW    :
                                            BELOW;

    reg [1:0] curr_level, prev_level;

    // Synchronous state update
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else if (decoded_level != curr_level) begin
            prev_level <= curr_level;
            curr_level <= decoded_level;
        end
    end

    // Nominal flow signals combinational logic
    assign fr0 = (curr_level == ABOVE)   ? 1'b0 :
                 (curr_level == BETWEEN1) ? 1'b1 :
                 (curr_level == BETWEEN0) ? 1'b1 :
                                            1'b1; // BELOW

    assign fr1 = (curr_level == ABOVE)   ? 1'b0 :
                 (curr_level == BETWEEN1) ? 1'b0 :
                 (curr_level == BETWEEN0) ? 1'b1 :
                                            1'b1; // BELOW

    assign fr2 = (curr_level == BELOW) ? 1'b1 : 1'b0;

    // Supplemental flow valve asserted if water level rising
    assign dfr = (curr_level > prev_level) ? 1'b1 : 1'b0;

endmodule