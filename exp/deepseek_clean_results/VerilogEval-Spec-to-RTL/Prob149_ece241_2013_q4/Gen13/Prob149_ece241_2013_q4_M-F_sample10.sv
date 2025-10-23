module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding using parameters
    parameter BELOW_S0 = 2'b00;
    parameter S0_TO_S1 = 2'b01;
    parameter S1_TO_S2 = 2'b10;
    parameter ABOVE_S2 = 2'b11;

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            BELOW_S0:   next_state = (s[0]) ? S0_TO_S1 : BELOW_S0;
            S0_TO_S1:   next_state = (s[1]) ? S1_TO_S2 : 
                                    (~s[0]) ? BELOW_S0 : S0_TO_S1;
            S1_TO_S2:   next_state = (s[2]) ? ABOVE_S2 :
                                    (~s[1]) ? S0_TO_S1 : S1_TO_S2;
            ABOVE_S2:   next_state = (~s[2]) ? S1_TO_S2 : ABOVE_S2;
            default:    next_state = BELOW_S0;
        endcase
    end

    // State registers
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Nominal flow outputs
    assign fr0 = (reset) ? 1'b1 : (current_state != ABOVE_S2);
    assign fr1 = (reset) ? 1'b1 : (current_state == S0_TO_S1 || current_state == BELOW_S0);
    assign fr2 = (reset) ? 1'b1 : (current_state == BELOW_S0);

    // Supplemental flow (active when water level is rising)
    assign dfr = (reset) ? 1'b1 : 
                ((current_state > prev_state) && 
                (current_state != ABOVE_S2));

endmodule