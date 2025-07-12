module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

    // Water level states encoding (lower number = lower water level)
    localparam BELOW    = 2'd0; // no sensors asserted: s=3'b000
    localparam BETWEEN0 = 2'd1; // only s[0] asserted: s=3'b100
    localparam BETWEEN1 = 2'd2; // s[0] and s[1] asserted: s=3'b110
    localparam ABOVE    = 2'd3; // all sensors asserted: s=3'b111

    reg [1:0] water_level_curr, water_level_prev;

    // Decode sensors exactly to water level states
    wire [1:0] water_level_next = 
          (s == 3'b111) ? ABOVE :
          (s == 3'b110) ? BETWEEN1 :
          (s == 3'b100) ? BETWEEN0 :
                          BELOW;

    always @(posedge clk) begin
        if (reset) begin
            water_level_curr <= BELOW;
            water_level_prev <= BELOW;
        end else begin
            water_level_prev <= water_level_curr;
            water_level_curr <= water_level_next;
        end
    end

    // Nominal flow valve outputs as per current water level
    // ABOVE: none asserted
    // BETWEEN1: fr0 only
    // BETWEEN0: fr0 and fr1
    // BELOW: fr0, fr1, fr2 all asserted
    wire nominal_fr0 = (water_level_curr != ABOVE);
    wire nominal_fr1 = (water_level_curr == BETWEEN0) || (water_level_curr == BELOW);
    wire nominal_fr2 = (water_level_curr == BELOW);

    // Supplemental flow valve asserted if water level is rising
    wire supplemental_dfr = (water_level_curr > water_level_prev);

    // On reset, all outputs asserted; otherwise nominal + supplemental logic
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule