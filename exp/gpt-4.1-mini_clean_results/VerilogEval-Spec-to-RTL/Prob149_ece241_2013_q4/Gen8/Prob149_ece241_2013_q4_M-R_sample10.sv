module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

    // State encoding for water levels
    localparam BELOW    = 2'd0; // no sensors asserted
    localparam BETWEEN0 = 2'd1; // only s[0] asserted
    localparam BETWEEN1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE    = 2'd3; // all sensors asserted s[0], s[1], s[2]

    // Combinational decoding of sensors to water level state
    wire [1:0] water_level_next;
    assign water_level_next = (s == 3'b111) ? ABOVE :
                             ((s[1] & s[0]) ? BETWEEN1 :
                             (s[0] ? BETWEEN0 : BELOW));

    reg [1:0] water_level_curr, water_level_prev;

    // Register water level states and track previous state on every clock
    always @(posedge clk) begin
        if (reset) begin
            water_level_curr <= BELOW;
            water_level_prev <= BELOW;
        end else begin
            water_level_prev <= water_level_curr;
            water_level_curr <= water_level_next;
        end
    end

    // Nominal flow valves combinational outputs based on current water level
    // ABOVE: none asserted
    // BETWEEN1: fr0 only
    // BETWEEN0: fr0, fr1
    // BELOW: fr0, fr1, fr2
    wire nominal_fr0 = (water_level_curr != ABOVE);
    wire nominal_fr1 = (water_level_curr == BETWEEN0) || (water_level_curr == BELOW);
    wire nominal_fr2 = (water_level_curr == BELOW);

    // Supplemental flow valve asserted if water level rising (current > previous)
    wire supplemental_dfr = (water_level_curr > water_level_prev);

    // Outputs: On reset, all asserted; otherwise nominal plus supplemental logic
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule