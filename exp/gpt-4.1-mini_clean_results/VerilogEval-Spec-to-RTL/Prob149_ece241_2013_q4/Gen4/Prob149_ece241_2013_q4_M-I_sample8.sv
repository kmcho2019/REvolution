module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // State encoding representing water levels (monotonically increasing)
    localparam BELOW       = 2'd0; // No sensors asserted
    localparam BETWEEN_1_0 = 2'd1; // Only s[0] asserted
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE       = 2'd3; // All sensors asserted

    reg [1:0] current_state, prev_state;

    // Decode water level from sensors, prioritizing highest levels first
    function [1:0] decode_region;
        input [2:0] sensors;
        begin
            // According to problem:
            // ABOVE: s[2], s[1], s[0] == 1
            // BETWEEN_2_1: s[2]==0, s[1]==1, s[0]==1
            // BETWEEN_1_0: s[2]==0, s[1]==0, s[0]==1
            // BELOW: no sensors asserted

            // Prioritize by highest water level first
            if (sensors[2] && sensors[1] && sensors[0]) begin
                decode_region = ABOVE;
            end else if (!sensors[2] && sensors[1] && sensors[0]) begin
                decode_region = BETWEEN_2_1;
            end else if (!sensors[2] && !sensors[1] && sensors[0]) begin
                decode_region = BETWEEN_1_0;
            end else if (sensors == 3'b000) begin
                decode_region = BELOW;
            end else begin
                // Handle partial/invalid sensor states by nearest region:
                // If highest sensor asserted => ABOVE
                if (sensors[2]) decode_region = ABOVE;
                else if (sensors[1]) decode_region = BETWEEN_2_1;
                else if (sensors[0]) decode_region = BETWEEN_1_0;
                else decode_region = BELOW;
            end
        end
    endfunction

    // State register updates
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
        end else begin
            prev_state <= current_state;
            current_state <= decode_region(s);
        end
    end

    // Nominal flow valve outputs combinational logic
    // Mapping from problem statement:
    // ABOVE: none asserted (all zero)
    // BETWEEN_2_1: fr0=1; fr1=0; fr2=0;
    // BETWEEN_1_0: fr0=1; fr1=1; fr2=0;
    // BELOW: fr0=1; fr1=1; fr2=1;

    reg fr0_reg, fr1_reg, fr2_reg;
    always @(*) begin
        case (current_state)
            ABOVE: begin
                fr0_reg = 1'b0;
                fr1_reg = 1'b0;
                fr2_reg = 1'b0;
            end
            BETWEEN_2_1: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b0;
                fr2_reg = 1'b0;
            end
            BETWEEN_1_0: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b0;
            end
            BELOW: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
            default: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
        endcase
    end

    // Supplemental flow valve (dfr)
    // Asserted only when water level rises: current_state > prev_state
    reg dfr_reg;
    always @(*) begin
        dfr_reg = (current_state > prev_state) ? 1'b1 : 1'b0;
    end

    // Output assignments
    assign fr0 = fr0_reg;
    assign fr1 = fr1_reg;
    assign fr2 = fr2_reg;
    assign dfr = dfr_reg;

endmodule