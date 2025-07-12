module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding (one-hot)
    localparam BELOW_S0   = 3'b000;
    localparam BTWN_S0_S1 = 3'b001;
    localparam BTWN_S1_S2 = 3'b010;
    localparam ABOVE_S2   = 3'b100;

    reg [2:0] current_state, next_state;
    reg [2:0] prev_sensors;
    wire rising;

    // Edge detection
    assign rising = (s > prev_sensors);

    // State transition logic
    always @(*) begin
        case (current_state)
            BELOW_S0:
                next_state = (s[0]) ? BTWN_S0_S1 : BELOW_S0;
            BTWN_S0_S1:
                if (s[1]) next_state = BTWN_S1_S2;
                else if (!s[0]) next_state = BELOW_S0;
                else next_state = BTWN_S0_S1;
            BTWN_S1_S2:
                if (s[2]) next_state = ABOVE_S2;
                else if (!s[1]) next_state = BTWN_S0_S1;
                else next_state = BTWN_S1_S2;
            ABOVE_S2:
                next_state = (!s[2]) ? BTWN_S1_S2 : ABOVE_S2;
            default:
                next_state = BELOW_S0;
        endcase
    end

    // State register and sensor history
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_sensors <= 3'b000;
        end else begin
            current_state <= next_state;
            prev_sensors <= s;
        end
    end

    // Output logic
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (current_state)
                BELOW_S0:   {fr2, fr1, fr0, dfr} = {1'b1, 1'b1, 1'b1, 1'b0};
                BTWN_S0_S1: {fr2, fr1, fr0, dfr} = {1'b0, 1'b1, 1'b1, rising};
                BTWN_S1_S2: {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b1, rising};
                ABOVE_S2:   {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b0, 1'b0};
                default:    {fr2, fr1, fr0, dfr} = {1'b1, 1'b1, 1'b1, 1'b0};
            endcase
        end
    end

endmodule