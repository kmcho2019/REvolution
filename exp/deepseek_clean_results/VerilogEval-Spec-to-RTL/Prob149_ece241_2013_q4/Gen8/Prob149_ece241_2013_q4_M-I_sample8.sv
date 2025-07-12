module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states for water levels
    localparam BELOW_S0  = 2'b00;
    localparam BTWN_S1S0 = 2'b01;
    localparam BTWN_S2S1 = 2'b10;
    localparam ABOVE_S2  = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg rising;

    // State transition logic
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW_S0;
            3'b001: next_state = BTWN_S1S0;
            3'b011: next_state = BTWN_S2S1;
            3'b111: next_state = ABOVE_S2;
            default: next_state = current_state; // maintain state for invalid patterns
        endcase
    end

    // State register and rising detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            rising <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            // Detect if water level is rising (previous state was lower)
            rising <= (current_state < next_state);
        end
    end

    // Output logic
    assign fr0 = reset ? 1'b1 : (current_state != ABOVE_S2);
    assign fr1 = reset ? 1'b1 : (current_state == BELOW_S0 || current_state == BTWN_S1S0);
    assign fr2 = reset ? 1'b1 : (current_state == BELOW_S0);
    assign dfr = reset ? 1'b1 : rising;

endmodule