module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

    // Define states as local parameters for clarity
    localparam BELOW    = 2'd0; // no sensors asserted
    localparam BETWEEN0 = 2'd1; // only s[0] asserted
    localparam BETWEEN1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE    = 2'd3; // all sensors asserted s[0], s[1], s[2]

    reg [1:0] curr_state;
    reg [1:0] prev_state;

    // Decode sensors to next state each clock cycle (combinational logic)
    wire [1:0] sensor_state;
    assign sensor_state = (s == 3'b111) ? ABOVE :
                          (s[1] & s[0]) ? BETWEEN1 :
                          (s[0])       ? BETWEEN0 :
                                         BELOW;

    always @(posedge clk) begin
        if (reset) begin
            curr_state <= BELOW;   // Reset state to BELOW level
            prev_state <= BELOW;   // Previous state also BELOW on reset
        end else begin
            // Update states only if water level changes
            if (sensor_state != curr_state) begin
                prev_state <= curr_state;
                curr_state <= sensor_state;
            end
        end
    end

    // Nominal flow valve outputs based on current water level
    // ABOVE: none asserted
    // BETWEEN1: fr0 only
    // BETWEEN0: fr0, fr1
    // BELOW: fr0, fr1, fr2
    wire nominal_fr0 = (curr_state != ABOVE);
    wire nominal_fr1 = (curr_state == BETWEEN0) || (curr_state == BELOW);
    wire nominal_fr2 = (curr_state == BELOW);

    // Supplemental flow valve dfr asserted if water level increased:
    // i.e. current state > previous state numerically
    wire supplemental_dfr = (curr_state > prev_state);

    // Outputs, all asserted on reset per requirement
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule