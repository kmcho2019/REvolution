module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // States correspond directly to sensor patterns
    localparam STATE_LOW      = 2'b00; // 000
    localparam STATE_MID_LOW  = 2'b01; // 001
    localparam STATE_MID_HIGH = 2'b10; // 011
    localparam STATE_HIGH     = 2'b11; // 111

    reg [1:0] current_state, next_state, prev_state;
    wire rising;

    // State transition and storage
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_LOW;
            prev_state <= STATE_LOW;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Next state logic (only valid sensor patterns)
    always @(*) begin
        case (s)
            3'b000: next_state = STATE_LOW;
            3'b001: next_state = STATE_MID_LOW;
            3'b011: next_state = STATE_MID_HIGH;
            3'b111: next_state = STATE_HIGH;
            default: next_state = current_state; // maintain state for invalid patterns
        endcase
    end

    // Rising detection (only between adjacent levels)
    assign rising = ((current_state == STATE_MID_LOW  && prev_state == STATE_LOW) ||
                    (current_state == STATE_MID_HIGH && prev_state == STATE_MID_LOW) ||
                    (current_state == STATE_HIGH     && prev_state == STATE_MID_HIGH));

    // Output logic (strictly follows specification)
    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            dfr <= rising; // dfr only depends on rising detection
            
            case (current_state)
                STATE_LOW:      {fr2, fr1, fr0} <= 3'b111;
                STATE_MID_LOW:   {fr2, fr1, fr0} <= 3'b011;
                STATE_MID_HIGH:  {fr2, fr1, fr0} <= 3'b001;
                STATE_HIGH:     {fr2, fr1, fr0} <= 3'b000;
                default:        {fr2, fr1, fr0} <= {fr2, fr1, fr0}; // hold during invalid patterns
            endcase
        end
    end

endmodule