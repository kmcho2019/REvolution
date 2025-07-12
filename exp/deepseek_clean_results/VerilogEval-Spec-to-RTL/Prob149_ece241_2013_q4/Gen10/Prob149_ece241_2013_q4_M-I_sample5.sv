module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding for water level zones
    localparam BELOW_S0  = 2'b00;
    localparam S0_TO_S1  = 2'b01;
    localparam S1_TO_S2  = 2'b10;
    localparam ABOVE_S2  = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;

    // Determine next state based on sensor readings
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW_S0;
            3'b001: next_state = S0_TO_S1;
            3'b011: next_state = S1_TO_S2;
            3'b111: next_state = ABOVE_S2;
            default: next_state = current_state; // Maintain state on invalid patterns
        endcase
    end

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Detect rising water level (state increase)
            dfr <= (next_state > current_state);

            // Output logic based on current state
            case (next_state)
                BELOW_S0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                S0_TO_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                S1_TO_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase
        end
    end

endmodule