module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define the water levels as parameters for clarity
    localparam BELOW       = 2'd0; // no sensors asserted (000)
    localparam BETWEEN_1_0 = 2'd1; // only s[0] asserted (001)
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1] asserted (011)
    localparam ABOVE       = 2'd3; // all sensors asserted (111)

    // Decode sensor input to water level state
    function automatic [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b000: decode_level = BELOW;
                3'b001: decode_level = BETWEEN_1_0;
                3'b011: decode_level = BETWEEN_2_1;
                3'b111: decode_level = ABOVE;
                default: decode_level = BELOW; // treat undefined patterns as BELOW for safety
            endcase
        end
    endfunction

    reg [1:0] current_level, last_stable_level;

    // On each clock, detect water level changes and update levels accordingly
    always @(posedge clk) begin
        if (reset) begin
            current_level     <= BELOW;
            last_stable_level <= BELOW;
        end else begin
            // Decode the new water level
            reg [1:0] new_level;
            new_level = decode_level(s);

            if (new_level != current_level) begin
                // Water level changed: store previous stable level and update current_level
                last_stable_level <= current_level;
                current_level     <= new_level;
            end
            // else no change: keep levels unchanged
        end
    end

    // Assign nominal flow valves based on current_level
    // From the table:
    // ABOVE (3'b111): fr0=0, fr1=0, fr2=0
    // BETWEEN_2_1 (3'b011): fr0=1, fr1=0, fr2=0
    // BETWEEN_1_0 (3'b001): fr0=1, fr1=1, fr2=0
    // BELOW (3'b000): fr0=1, fr1=1, fr2=1
    assign fr0 = (current_level != ABOVE) ? 1'b1 : 1'b0;
    assign fr1 = (current_level == BETWEEN_1_0 || current_level == BELOW) ? 1'b1 : 1'b0;
    assign fr2 = (current_level == BELOW) ? 1'b1 : 1'b0;

    // Supplemental flow valve (dfr) asserted if current_level > last_stable_level
    // Because levels have ascending order: BELOW=0 < BETWEEN_1_0=1 < BETWEEN_2_1=2 < ABOVE=3
    reg dfr_reg;
    always @(posedge clk) begin
        if (reset)
            dfr_reg <= 1'b1;
        else
            dfr_reg <= (current_level > last_stable_level);
    end

    assign dfr = dfr_reg;

endmodule