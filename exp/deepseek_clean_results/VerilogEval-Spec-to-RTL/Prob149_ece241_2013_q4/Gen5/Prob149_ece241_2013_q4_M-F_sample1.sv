module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding for water level zones
    localparam ABOVE_S2      = 2'b00;
    localparam BETWEEN_S2_S1 = 2'b01;
    localparam BETWEEN_S1_S0 = 2'b10;
    localparam BELOW_S0      = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg rising;

    // Next state logic based directly on sensor inputs
    always @(*) begin
        case (s)
            3'b111:  next_state = ABOVE_S2;
            3'b011:  next_state = BETWEEN_S2_S1;
            3'b001:  next_state = BETWEEN_S1_S0;
            3'b000:  next_state = BELOW_S0;
            default: next_state = current_state; // Invalid patterns hold current state
        endcase
    end

    // State transition and rising edge detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            rising <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Detect rising water (moving to numerically lower state number)
            rising <= (next_state < current_state);
        end
    end

    // Output logic - reset overrides all outputs
    assign fr0 = reset ? 1'b1 : (current_state != ABOVE_S2);
    assign fr1 = reset ? 1'b1 : (current_state >= BETWEEN_S1_S0);
    assign fr2 = reset ? 1'b1 : (current_state == BELOW_S0);
    assign dfr = reset ? 1'b1 : rising;

endmodule