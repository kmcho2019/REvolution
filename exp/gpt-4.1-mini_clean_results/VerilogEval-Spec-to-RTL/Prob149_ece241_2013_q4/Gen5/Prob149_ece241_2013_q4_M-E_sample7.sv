module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define canonical water levels as numeric values (0=lowest to 3=highest)
    localparam LEVEL_BELOW       = 2'd0; // no sensors asserted
    localparam LEVEL_BETWEEN_1_0 = 2'd1; // s=001
    localparam LEVEL_BETWEEN_2_1 = 2'd2; // s=011
    localparam LEVEL_ABOVE       = 2'd3; // s=111

    // Store previous sensor pattern and levels synchronously
    reg [2:0] prev_sensors;
    reg [1:0] prev_level;

    // Current decoded level register (registered for synchronous operation)
    reg [1:0] current_level;

    // Function: map sensors to canonical water level
    // Maps any sensor pattern to closest canonical level at or below that pattern
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Match highest valid water level pattern <= sensors pattern
            // We'll check from highest (ABOVE) down:
            // ABOVE: s=111
            if (sensors[2] && sensors[1] && sensors[0]) begin
                decode_level = LEVEL_ABOVE;
            end 
            // BETWEEN_2_1: s=011 (s[2]=0,s[1]=1,s[0]=1)
            else if (!sensors[2] && sensors[1] && sensors[0]) begin
                decode_level = LEVEL_BETWEEN_2_1;
            end
            // BETWEEN_1_0: s=001 (only s[0] asserted)
            else if (!sensors[2] && !sensors[1] && sensors[0]) begin
                decode_level = LEVEL_BETWEEN_1_0;
            end
            // BELOW: no sensors asserted
            else if (sensors == 3'b000) begin
                decode_level = LEVEL_BELOW;
            end
            else begin
                // For intermediate or unexpected patterns, find closest lower pattern
                // For example, if s=010 or s=100 or s=101:
                // pick level based on highest asserted sensors going downwards

                if (sensors[2]) begin
                    // If highest sensor asserted alone or with partial: ABOVE
                    decode_level = LEVEL_ABOVE;
                end
                else if (sensors[1]) begin
                    // s[1] asserted without s[2], map to BETWEEN_2_1 if s[0] also asserted
                    if (sensors[0])
                        decode_level = LEVEL_BETWEEN_2_1;
                    else
                        // s[1] only or with s[2] missing s[0]: assign to BETWEEN_2_1 for safety
                        decode_level = LEVEL_BETWEEN_2_1;
                end
                else if (sensors[0]) begin
                    decode_level = LEVEL_BETWEEN_1_0;
                end
                else begin
                    decode_level = LEVEL_BELOW;
                end
            end
        end
    endfunction

    // Synchronize input sensors and decode current level on clock
    always @(posedge clk) begin
        if (reset) begin
            prev_sensors <= 3'b000; // No sensors asserted
            prev_level   <= LEVEL_BELOW;
            current_level <= LEVEL_BELOW;
        end else begin
            prev_sensors <= s;
            prev_level   <= current_level;
            current_level <= decode_level(s);
        end
    end

    // Detect rise: supplemental flow valve opens only if water level strictly rises
    wire rising_level = (current_level > prev_level);

    // Nominal flow valves output combinational logic based on current level:
    // From problem:
    // ABOVE (3): no valves open (all zero)
    // BETWEEN_2_1 (2): fr0=1, fr1=0, fr2=0
    // BETWEEN_1_0 (1): fr0=1, fr1=1, fr2=0
    // BELOW (0): fr0=1, fr1=1, fr2=1

    reg fr0_reg, fr1_reg, fr2_reg;
    always @(*) begin
        case (current_level)
            LEVEL_ABOVE: begin
                fr0_reg = 1'b0;
                fr1_reg = 1'b0;
                fr2_reg = 1'b0;
            end
            LEVEL_BETWEEN_2_1: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b0;
                fr2_reg = 1'b0;
            end
            LEVEL_BETWEEN_1_0: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b0;
            end
            LEVEL_BELOW: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
            default: begin
                // Defensive default: all valves open
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
        endcase
    end

    // Assign outputs
    assign fr0 = fr0_reg;
    assign fr1 = fr1_reg;
    assign fr2 = fr2_reg;
    assign dfr = rising_level;

endmodule