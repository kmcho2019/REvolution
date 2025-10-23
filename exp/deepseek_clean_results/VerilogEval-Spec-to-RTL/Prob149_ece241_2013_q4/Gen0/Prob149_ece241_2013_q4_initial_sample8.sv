module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states
    localparam [1:0] ABOVE_S2     = 2'b00,
                    BETWEEN_S2_S1 = 2'b01,
                    BETWEEN_S1_S0 = 2'b10,
                    BELOW_S0      = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg needs_supplemental;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            needs_supplemental <= 1'b0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Determine if we need supplemental flow
            case (current_state)
                ABOVE_S2:     needs_supplemental <= 1'b0;
                BETWEEN_S2_S1: needs_supplemental <= (next_state == BETWEEN_S1_S0 || next_state == BELOW_S0);
                BETWEEN_S1_S0: needs_supplemental <= (next_state == BELOW_S0);
                BELOW_S0:     needs_supplemental <= 1'b0;
                default:      needs_supplemental <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (s)
            3'b111: next_state = ABOVE_S2;
            3'b011: next_state = BETWEEN_S2_S1;
            3'b001: next_state = BETWEEN_S1_S0;
            3'b000: next_state = BELOW_S0;
            default: next_state = BELOW_S0; // Default to lowest level if invalid sensor input
        endcase
    end

    // Output logic
    assign fr0 = (current_state == BETWEEN_S2_S1 || 
                 current_state == BETWEEN_S1_S0 || 
                 current_state == BELOW_S0);
    
    assign fr1 = (current_state == BETWEEN_S1_S0 || 
                 current_state == BELOW_S0);
    
    assign fr2 = (current_state == BELOW_S0);
    
    // Supplemental flow is needed when moving to a lower level
    assign dfr = needs_supplemental;

endmodule