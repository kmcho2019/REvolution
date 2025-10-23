module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Revised state encoding (higher binary = higher water level)
    localparam BELOW_S0    = 2'b00;  // No sensors
    localparam BTWN_S1_S0  = 2'b01;  // s[0]
    localparam BTWN_S2_S1  = 2'b10;  // s[0],s[1]
    localparam ABOVE_S2    = 2'b11;  // s[0],s[1],s[2]

    reg [1:0] current_state, prev_state;
    reg rising;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            rising <= 1'b0;
        end else begin
            prev_state <= current_state;
            casez(s)
                3'b??1: current_state <= BTWN_S1_S0;
                3'b?11: current_state <= BTWN_S2_S1;
                3'b111: current_state <= ABOVE_S2;
                default: current_state <= BELOW_S0;
            endcase
            rising <= (current_state > prev_state);
        end
    end

    // Output logic
    assign fr0 = reset ? 1'b1 : (current_state != ABOVE_S2);
    assign fr1 = reset ? 1'b1 : (current_state >= BTWN_S2_S1);
    assign fr2 = reset ? 1'b1 : (current_state == BELOW_S0);
    assign dfr = reset ? 1'b1 : (rising && (current_state != ABOVE_S2));

endmodule