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

    // Decode water level combinationally using conditional assign
    // Mapping sensor patterns strictly as per problem statement
    wire [1:0] decoded_level = (s == 3'b111) ? ABOVE :
                               (s == 3'b011) ? BETWEEN1 :
                               (s == 3'b001) ? BETWEEN0 :
                               (s == 3'b000) ? BELOW :
                               BELOW; // default case

    // Sequential update of water levels with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            prev_level <= curr_level;
            curr_level <= decoded_level;
        end
    end

    // Nominal flow outputs combinationally derived from current_level
    wire nom_fr0 = (curr_level != ABOVE);
    wire nom_fr1 = (curr_level == BETWEEN0) || (curr_level == BELOW);
    wire nom_fr2 = (curr_level == BELOW);

    // Supplemental flow valve asserted if water level rose compared to previous
    wire supplemental = (curr_level > prev_level);

    // Outputs: on reset all asserted, else normal logic
    assign fr0 = reset ? 1'b1 : nom_fr0;
    assign fr1 = reset ? 1'b1 : nom_fr1;
    assign fr2 = reset ? 1'b1 : nom_fr2;
    assign dfr = reset ? 1'b1 : supplemental;

endmodule