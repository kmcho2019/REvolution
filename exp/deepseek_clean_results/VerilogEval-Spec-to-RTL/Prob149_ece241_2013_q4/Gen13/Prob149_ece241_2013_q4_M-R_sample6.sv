module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Binary state encoding
    localparam BELOW_S0   = 2'b00;
    localparam S0_TO_S1   = 2'b01;
    localparam S1_TO_S2   = 2'b10;
    localparam ABOVE_S2   = 2'b11;

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic (combinational)
    assign next_state = 
        (current_state == BELOW_S0) ? (s[0] ? S0_TO_S1 : BELOW_S0) :
        (current_state == S0_TO_S1) ? (s[1] ? S1_TO_S2 : (~s[0] ? BELOW_S0 : S0_TO_S1)) :
        (current_state == S1_TO_S2) ? (s[2] ? ABOVE_S2 : (~s[1] ? S0_TO_S1 : S1_TO_S2)) :
        (current_state == ABOVE_S2) ? (~s[2] ? S1_TO_S2 : ABOVE_S2) :
        BELOW_S0;  // default

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
    assign fr0 = reset ? 1'b1 : (current_state != ABOVE_S2);
    assign fr1 = reset ? 1'b1 : (current_state == S0_TO_S1 || current_state == BELOW_S0);
    assign fr2 = reset ? 1'b1 : (current_state == BELOW_S0);

    // Supplemental flow (active when water level is rising)
    assign dfr = reset ? 1'b1 : 
                ((current_state > prev_state) && 
                (current_state != ABOVE_S2));

endmodule