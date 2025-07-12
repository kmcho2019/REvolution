module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level states
    localparam ABOVE_S2    = 2'b00;
    localparam BTWN_S2_S1 = 2'b01;
    localparam BTWN_S1_S0 = 2'b10;
    localparam BELOW_S0    = 2'b11;

    reg [1:0] current_state, prev_state;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to BELOW_S0 state with all outputs asserted
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update previous state
            prev_state <= current_state;

            // Determine current state based on sensors
            casez(s)
                3'b111:  current_state <= ABOVE_S2;
                3'b011:  current_state <= BTWN_S2_S1;
                3'b001:  current_state <= BTWN_S1_S0;
                3'b000:  current_state <= BELOW_S0;
                default: current_state <= current_state; // maintain state on invalid inputs
            endcase

            // Set outputs based on current state
            case(current_state)
                ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                BTWN_S2_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                BTWN_S1_S0: begin
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

            // Determine if water level is rising (for dfr)
            dfr <= (current_state > prev_state) && (current_state != ABOVE_S2);
        end
    end

endmodule