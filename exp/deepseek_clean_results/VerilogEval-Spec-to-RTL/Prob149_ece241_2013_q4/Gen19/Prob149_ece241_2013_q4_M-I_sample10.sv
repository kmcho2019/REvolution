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
    localparam STATE_BELOW = 2'b00;
    localparam STATE_LOW   = 2'b01;
    localparam STATE_MID   = 2'b10;
    localparam STATE_HIGH  = 2'b11;

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b000: next_state = STATE_BELOW;
            3'b001: next_state = STATE_LOW;
            3'b011: next_state = STATE_MID;
            3'b111: next_state = STATE_HIGH;
            default: next_state = current_state; // Maintain state for invalid sensor patterns
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            STATE_BELOW: {fr2, fr1, fr0} = 3'b111;
            STATE_LOW:   {fr2, fr1, fr0} = 3'b011;
            STATE_MID:   {fr2, fr1, fr0} = 3'b001;
            STATE_HIGH:  {fr2, fr1, fr0} = 3'b000;
            default:     {fr2, fr1, fr0} = 3'b111;
        endcase
    end

    // State and transition detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            // Detect rising water level transitions
            dfr <= (next_state > current_state);
        end
    end

endmodule