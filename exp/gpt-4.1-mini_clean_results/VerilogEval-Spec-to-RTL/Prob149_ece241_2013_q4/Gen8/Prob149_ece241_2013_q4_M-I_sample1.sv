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

    reg [1:0] curr_state, next_state;
    reg [1:0] prev_state;

    // Decode sensors to state (combinational)
    wire [1:0] sensor_state = (s == 3'b111) ? ABOVE :
                             ((s[1] & s[0]) ? BETWEEN1 :
                             (s[0]) ? BETWEEN0 :
                             BELOW);

    // Next state logic: always equal to sensor_state (direct decoding)
    always @(*) begin
        next_state = sensor_state;
    end

    // State registers and previous state tracking
    // prev_state updated only when state changes, to capture level before last change
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= BELOW;
            prev_state <= BELOW;
        end else begin
            if (next_state != curr_state) begin
                prev_state <= curr_state;  // store previous level before state update
                curr_state <= next_state;
            end
        end
    end

    // Nominal flow valve signals per specification:
    // ABOVE: none asserted
    // BETWEEN1: fr0 only
    // BETWEEN0: fr0, fr1
    // BELOW: fr0, fr1, fr2
    wire nominal_fr0 = (curr_state != ABOVE);
    wire nominal_fr1 = (curr_state == BETWEEN0) || (curr_state == BELOW);
    wire nominal_fr2 = (curr_state == BELOW);

    // Supplemental valve dfr: asserted when water level increased
    // (current level numerically greater than previous level)
    wire supplemental_dfr = (curr_state > prev_state);

    // Output assignments with synchronous reset forcing all valves on
    assign fr0 = reset ? 1'b1 : nominal_fr0;
    assign fr1 = reset ? 1'b1 : nominal_fr1;
    assign fr2 = reset ? 1'b1 : nominal_fr2;
    assign dfr = reset ? 1'b1 : supplemental_dfr;

endmodule