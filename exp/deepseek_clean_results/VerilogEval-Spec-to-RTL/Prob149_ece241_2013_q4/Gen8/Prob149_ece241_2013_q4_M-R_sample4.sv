module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // New state encoding (higher number = higher water level)
    // 00: Below s[0] (lowest level)
    // 01: Between s[1] and s[0]
    // 10: Between s[2] and s[1]
    // 11: Above s[2] (highest level)
    localparam LEVEL_BELOW_S0       = 2'b00;
    localparam LEVEL_BETWEEN_S1_S0  = 2'b01;
    localparam LEVEL_BETWEEN_S2_S1  = 2'b10;
    localparam LEVEL_ABOVE_S2       = 2'b11;

    reg [1:0] current_level;
    reg [1:0] prev_level;
    reg water_rising;

    // Combinatorial level detection
    wire [1:0] next_level;
    assign next_level = (s == 3'b111) ? LEVEL_ABOVE_S2 :
                       (s == 3'b011) ? LEVEL_BETWEEN_S2_S1 :
                       (s == 3'b001) ? LEVEL_BETWEEN_S1_S0 :
                       LEVEL_BELOW_S0;  // default case

    // Detect water level changes
    always @(*) begin
        water_rising = (next_level > current_level);
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
        end
    end

    // Output assignments
    assign fr2 = (current_level == LEVEL_BELOW_S0);
    assign fr1 = (current_level == LEVEL_BELOW_S0) || 
                 (current_level == LEVEL_BETWEEN_S1_S0);
    assign fr0 = (current_level != LEVEL_ABOVE_S2);
    assign dfr = water_rising && (current_level != LEVEL_ABOVE_S2);

endmodule