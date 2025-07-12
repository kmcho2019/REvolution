module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states as 2-bit codes
    localparam BELOW    = 2'd0;
    localparam BETWEEN0 = 2'd1; // Between s[1] and s[0]
    localparam BETWEEN1 = 2'd2; // Between s[2] and s[1]
    localparam ABOVE    = 2'd3;

    // Combinational decoding of water level from sensor inputs
    wire [1:0] decoded_level;
    assign decoded_level =
        (s == 3'b111) ? ABOVE    : // all sensors asserted
        (s == 3'b110) ? BETWEEN1 : // s[2], s[1] asserted, s[0] deasserted
        (s == 3'b100) ? BETWEEN0 : // only s[2] asserted
        (s == 3'b000) ? BELOW    : // no sensors asserted
        // For any other sensor pattern, determine based on sensor bits:
        // Since the spec only defines exact patterns, treat others as BELOW for safety
        BELOW;

    // Registers to hold current and previous water level states
    reg [1:0] curr_level_reg, prev_level_reg;

    always @(posedge clk) begin
        if (reset) begin
            curr_level_reg <= BELOW;
            prev_level_reg <= BELOW;
        end else begin
            prev_level_reg <= curr_level_reg;
            curr_level_reg <= decoded_level;
        end
    end

    // Generate nominal flow control signals based on current level
    wire nom_fr0 = (curr_level_reg == BETWEEN0) || (curr_level_reg == BETWEEN1) || (curr_level_reg == BELOW);
    wire nom_fr1 = (curr_level_reg == BETWEEN0) || (curr_level_reg == BELOW);
    wire nom_fr2 = (curr_level_reg == BELOW);

    // Supplemental flow valve enabled when level rising compared to previous
    wire supplemental_dfr = (curr_level_reg > prev_level_reg);

    // Outputs: on reset all asserted; otherwise nominal + supplemental dfr
    assign fr0 = reset ? 1'b1 : nom_fr0;
    assign fr1 = reset ? 1'b1 : nom_fr1;
    assign fr2 = reset ? 1'b1 : nom_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule