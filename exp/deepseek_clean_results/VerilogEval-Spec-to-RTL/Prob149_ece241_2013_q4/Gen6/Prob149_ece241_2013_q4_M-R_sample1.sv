module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Reverse encoding for more intuitive comparison (higher number = higher water)
    localparam LEVEL_BELOW_S0  = 2'b00;  // No sensors
    localparam LEVEL_BETWEEN_S1_S0 = 2'b01;  // s[0]
    localparam LEVEL_BETWEEN_S2_S1 = 2'b10;  // s[0],s[1]
    localparam LEVEL_ABOVE_S2  = 2'b11;  // s[0],s[1],s[2]

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Continuous assignments for flow rate outputs
    assign fr0 = (current_level == LEVEL_BETWEEN_S2_S1) || 
                 (current_level == LEVEL_BETWEEN_S1_S0) || 
                 (current_level == LEVEL_BELOW_S0);
    
    assign fr1 = (current_level == LEVEL_BETWEEN_S1_S0) || 
                 (current_level == LEVEL_BELOW_S0);
    
    assign fr2 = (current_level == LEVEL_BELOW_S0);

    // Supplemental flow (1 when water level is rising)
    assign dfr = (current_level > prev_level);

    // Level detection and state update
    always @(*) begin
        case (s)
            3'b000: current_level = LEVEL_BELOW_S0;
            3'b001: current_level = LEVEL_BETWEEN_S1_S0;
            3'b011: current_level = LEVEL_BETWEEN_S2_S1;
            3'b111: current_level = LEVEL_ABOVE_S2;
            default: current_level = LEVEL_BELOW_S0; // Default to lowest level
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= LEVEL_BELOW_S0; // Reset state (all outputs will be 1)
        end else begin
            prev_level <= current_level;
        end
    end

endmodule