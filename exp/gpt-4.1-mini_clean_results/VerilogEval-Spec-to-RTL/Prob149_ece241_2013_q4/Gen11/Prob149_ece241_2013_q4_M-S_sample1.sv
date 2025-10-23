module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states as 2-bit values
    localparam BELOW    = 2'd0;
    localparam BETWEEN0 = 2'd1; // Between s[1] and s[0]
    localparam BETWEEN1 = 2'd2; // Between s[2] and s[1]
    localparam ABOVE    = 2'd3;

    reg [1:0] curr_level, prev_level;

    // Decode water level from sensor pattern exactly as specified
    wire [1:0] decoded_level;
    always @(*) begin
        case (s)
            3'b111: decoded_level = ABOVE;    // Above s[2]
            3'b011: decoded_level = BETWEEN1; // Between s[2] and s[1] (s[0], s[1] asserted)
            3'b001: decoded_level = BETWEEN0; // Between s[1] and s[0] (s[0] asserted)
            3'b000: decoded_level = BELOW;    // Below s[0]
            default: decoded_level = BELOW;   // Any other pattern treated as BELOW
        endcase
    end

    // Sequential update of current and previous water levels
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            prev_level <= curr_level;
            curr_level <= decoded_level;
        end
    end

    // Nominal flow outputs based on current water level
    // According to table:
    // ABOVE: no nominal flow (all 0)
    // BETWEEN1: fr0
    // BETWEEN0: fr0, fr1
    // BELOW: fr0, fr1, fr2
    wire nom_fr0 = (curr_level != ABOVE);
    wire nom_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nom_fr2 = (curr_level == BELOW);

    // Supplemental flow valve asserted if current level rose compared to previous
    wire supplemental = (curr_level > prev_level);

    // Outputs: on reset all asserted, else according to nominal and supplemental
    assign fr0 = reset ? 1'b1 : nom_fr0;
    assign fr1 = reset ? 1'b1 : nom_fr1;
    assign fr2 = reset ? 1'b1 : nom_fr2;
    assign dfr = reset ? 1'b1 : supplemental;

endmodule