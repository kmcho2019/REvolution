module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level encodings
    localparam BELOW    = 2'd0;
    localparam BETWEEN0 = 2'd1;  // Between s[1] and s[0]
    localparam BETWEEN1 = 2'd2;  // Between s[2] and s[1]
    localparam ABOVE    = 2'd3;

    // Decode sensor pattern exactly per specification
    // s[2] is highest sensor, s[1] middle, s[0] lowest
    wire is_above    = (s == 3'b111); // all sensors asserted
    wire is_between1 = (s == 3'b011); // s[2]=0, s[1]=1, s[0]=1
    wire is_between0 = (s == 3'b001); // s[2]=0, s[1]=0, s[0]=1
    wire is_below    = (s == 3'b000); // none asserted

    // Default next level to BELOW if no exact match (safe fallback)
    wire [1:0] next_level = is_above    ? ABOVE    :
                           is_between1 ? BETWEEN1 :
                           is_between0 ? BETWEEN0 :
                                         BELOW;

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    wire level_changed = (next_level != curr_level);

    // Synchronous state update
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            // Update prev_level only on level change
            if (level_changed) begin
                prev_level <= curr_level;
            end
            // Always update curr_level to next_level
            curr_level <= next_level;
        end
    end

    // Nominal flows combinational, per specification
    // ABOVE: none asserted
    // BETWEEN1: fr0 only
    // BETWEEN0: fr0 and fr1
    // BELOW: fr0, fr1, fr2
    reg fr0_r, fr1_r, fr2_r;

    always @(*) begin
        case (curr_level)
            ABOVE: begin
                fr0_r = 1'b0;
                fr1_r = 1'b0;
                fr2_r = 1'b0;
            end
            BETWEEN1: begin
                fr0_r = 1'b1;
                fr1_r = 1'b0;
                fr2_r = 1'b0;
            end
            BETWEEN0: begin
                fr0_r = 1'b1;
                fr1_r = 1'b1;
                fr2_r = 1'b0;
            end
            BELOW: begin
                fr0_r = 1'b1;
                fr1_r = 1'b1;
                fr2_r = 1'b1;
            end
            default: begin
                // Defensive default to all open
                fr0_r = 1'b1;
                fr1_r = 1'b1;
                fr2_r = 1'b1;
            end
        endcase
    end

    // Supplemental flow valve logic combinational
    // Assert dfr when water level rises from prev_level to curr_level on level change
    wire rising = level_changed && (curr_level > prev_level);

    reg dfr_r;
    always @(posedge clk) begin
        if (reset) begin
            dfr_r <= 1'b1;
        end else begin
            dfr_r <= rising;
        end
    end

    // Outputs synchronous and active high, during reset all asserted per spec
    assign fr0 = reset ? 1'b1 : fr0_r;
    assign fr1 = reset ? 1'b1 : fr1_r;
    assign fr2 = reset ? 1'b1 : fr2_r;
    assign dfr = reset ? 1'b1 : dfr_r;

endmodule