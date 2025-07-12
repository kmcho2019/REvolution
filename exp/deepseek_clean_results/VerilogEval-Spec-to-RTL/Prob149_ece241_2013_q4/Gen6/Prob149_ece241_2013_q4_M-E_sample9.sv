module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding
    localparam BELOW      = 2'b00;  // No sensors active
    localparam BETWEEN_LOW = 2'b01;  // Only s[0] active
    localparam BETWEEN_MID = 2'b10;  // s[1] and s[0] active
    localparam ABOVE      = 2'b11;  // All sensors active

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg rising_edge_detected;

    // State transition logic
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW;
            3'b001: next_state = BETWEEN_LOW;
            3'b011: next_state = BETWEEN_MID;
            3'b111: next_state = ABOVE;
            default: next_state = current_state; // Handle invalid states
        endcase
    end

    // State registers and transition detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
            rising_edge_detected <= 1'b0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            // Detect rising water level (current > previous)
            rising_edge_detected <= (current_state < next_state);
        end
    end

    // Output logic
    assign fr2 = (current_state == BELOW);
    assign fr1 = (current_state == BELOW) || (current_state == BETWEEN_LOW);
    assign fr0 = (current_state != ABOVE);
    assign dfr = rising_edge_detected && (current_state != ABOVE);

endmodule