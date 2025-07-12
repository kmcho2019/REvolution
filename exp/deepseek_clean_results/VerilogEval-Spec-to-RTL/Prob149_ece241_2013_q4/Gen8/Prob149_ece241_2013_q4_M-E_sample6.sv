module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Explicit state definitions
    typedef enum logic [1:0] {
        ABOVE_S2,       // All sensors active
        BETWEEN_S2_S1,  // s[1:0] active
        BETWEEN_S1_S0,   // s[0] active
        BELOW_S0        // No sensors active
    } water_state_t;

    water_state_t current_state, next_state;
    reg rising;  // Direction indicator (1 when water level is rising)

    // State transition logic
    always @(*) begin
        case (s)
            3'b111: next_state = ABOVE_S2;
            3'b011: next_state = BETWEEN_S2_S1;
            3'b001: next_state = BETWEEN_S1_S0;
            3'b000: next_state = BELOW_S0;
            default: next_state = BELOW_S0; // Safe default
        endcase
    end

    // Direction detection (combinational)
    always @(*) begin
        case ({current_state, next_state})
            {ABOVE_S2, ABOVE_S2}:       rising = 1'b0;
            {ABOVE_S2, BETWEEN_S2_S1}:  rising = 1'b0;
            {ABOVE_S2, BETWEEN_S1_S0}: rising = 1'b0;
            {ABOVE_S2, BELOW_S0}:       rising = 1'b0;
            
            {BETWEEN_S2_S1, ABOVE_S2}:  rising = 1'b1;
            {BETWEEN_S2_S1, BETWEEN_S2_S1}: rising = 1'b0;
            {BETWEEN_S2_S1, BETWEEN_S1_S0}: rising = 1'b0;
            {BETWEEN_S2_S1, BELOW_S0}:      rising = 1'b0;
            
            {BETWEEN_S1_S0, ABOVE_S2}:      rising = 1'b1;
            {BETWEEN_S1_S0, BETWEEN_S2_S1}: rising = 1'b1;
            {BETWEEN_S1_S0, BETWEEN_S1_S0}:  rising = 1'b0;
            {BETWEEN_S1_S0, BELOW_S0}:       rising = 1'b0;
            
            {BELOW_S0, ABOVE_S2}:       rising = 1'b1;
            {BELOW_S0, BETWEEN_S2_S1}:  rising = 1'b1;
            {BELOW_S0, BETWEEN_S1_S0}:   rising = 1'b1;
            {BELOW_S0, BELOW_S0}:       rising = 1'b0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            current_state <= next_state;
            
            // Nominal flow outputs
            case (next_state)
                ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                BETWEEN_S2_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                BETWEEN_S1_S0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                BELOW_S0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
            endcase
            
            // Supplemental flow output
            dfr <= rising;
        end
    end

endmodule