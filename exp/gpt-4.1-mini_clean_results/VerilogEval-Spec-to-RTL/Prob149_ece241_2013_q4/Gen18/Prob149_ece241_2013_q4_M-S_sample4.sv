module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water levels for clarity
    localparam LEVEL_BELOW  = 2'd0; // No sensors asserted
    localparam LEVEL_S0     = 2'd1; // Only s[0] asserted
    localparam LEVEL_S1_S0  = 2'd2; // s[0] and s[1] asserted
    localparam LEVEL_ABOVE  = 2'd3; // s[0], s[1], s[2] asserted

    reg [1:0] prev_level, current_level;

    // Decode sensor inputs to water level
    wire [1:0] decoded_level = (s == 3'b111) ? LEVEL_ABOVE :
                               (s == 3'b011) ? LEVEL_S1_S0 :
                               (s == 3'b001) ? LEVEL_S0 :
                               LEVEL_BELOW;

    // Sequentially track current and previous water levels
    always @(posedge clk) begin
        if (reset) begin
            prev_level    <= LEVEL_BELOW;
            current_level <= LEVEL_BELOW;
        end else begin
            prev_level    <= current_level;
            current_level <= decoded_level;
        end
    end

    // Supplemental flow valve asserted when water level rises
    assign dfr = (current_level > prev_level);

    // Nominal flow outputs combinationally assigned based on current water level
    assign {fr2, fr1, fr0} = (current_level == LEVEL_ABOVE)  ? 3'b000 :
                            (current_level == LEVEL_S1_S0) ? 3'b001 :
                            (current_level == LEVEL_S0)    ? 3'b011 :
                            /* LEVEL_BELOW */               3'b111;

endmodule