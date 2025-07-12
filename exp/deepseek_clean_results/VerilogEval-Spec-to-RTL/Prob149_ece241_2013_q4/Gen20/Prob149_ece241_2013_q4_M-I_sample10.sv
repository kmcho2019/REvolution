module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding
    localparam BELOW_S0   = 2'b00;
    localparam BTWN_S0_S1 = 2'b01;
    localparam BTWN_S1_S2 = 2'b10;
    localparam ABOVE_S2   = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            BELOW_S0:
                next_state = s[0] ? BTWN_S0_S1 : BELOW_S0;
            BTWN_S0_S1:
                if (s[1]) next_state = BTWN_S1_S2;
                else if (!s[0]) next_state = BELOW_S0;
                else next_state = BTWN_S0_S1;
            BTWN_S1_S2:
                if (s[2]) next_state = ABOVE_S2;
                else if (!s[1]) next_state = BTWN_S0_S1;
                else next_state = BTWN_S1_S2;
            ABOVE_S2:
                if (!s[2]) next_state = BTWN_S1_S2;
                else next_state = ABOVE_S2;
        endcase
    end

    // State register and transition detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            // Default outputs
            fr2 = 0;
            fr1 = 0;
            fr0 = 0;
            dfr = 0;

            case (current_state)
                BELOW_S0:   {fr2, fr1, fr0} = 3'b111;
                BTWN_S0_S1: {fr1, fr0} = 2'b11;
                BTWN_S1_S2: fr0 = 1'b1;
                ABOVE_S2:   ; // All outputs remain 0
            endcase

            // dfr is high when moving to a higher state
            dfr = (current_state > prev_state);
        end
    end

endmodule