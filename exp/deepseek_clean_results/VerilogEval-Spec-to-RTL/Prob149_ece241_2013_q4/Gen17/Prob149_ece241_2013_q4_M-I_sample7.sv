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
    localparam BELOW_S0    = 2'b00;  // Lowest level
    localparam BTWN_S1_S0  = 2'b01;
    localparam BTWN_S2_S1  = 2'b10;
    localparam ABOVE_S2    = 2'b11;  // Highest level

    reg [1:0] current_state, prev_state;
    reg rising;
    wire [1:0] next_state;

    // Determine next state based on sensors
    assign next_state = (s == 3'b000) ? BELOW_S0 :
                       (s == 3'b001) ? BTWN_S1_S0 :
                       (s == 3'b011) ? BTWN_S2_S1 :
                       ABOVE_S2;

    // State transition and rising detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            rising <= 1'b0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            // Detect rising water (new state > previous state)
            rising <= (next_state > current_state);
        end
    end

    // Output logic (active high)
    assign fr0 = reset ? 1'b1 : (current_state != ABOVE_S2);
    assign fr1 = reset ? 1'b1 : (current_state >= BTWN_S1_S0);
    assign fr2 = reset ? 1'b1 : (current_state == BELOW_S0);
    
    // Supplemental flow (active when water rising and not at highest level)
    assign dfr = reset ? 1'b1 : (rising && (current_state != ABOVE_S2));

endmodule