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
    localparam STATE_HIGH    = 2'b11;
    localparam STATE_MID_HIGH = 2'b10;
    localparam STATE_MID_LOW  = 2'b01;
    localparam STATE_LOW     = 2'b00;

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

    // Next state logic
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_HIGH;
            3'b011: next_state = STATE_MID_HIGH;
            3'b001: next_state = STATE_MID_LOW;
            3'b000: next_state = STATE_LOW;
            default: next_state = current_state; // maintain state for invalid patterns
        endcase
    end

    // Rising detection (only valid transitions)
    assign rising = (current_state > prev_state) && 
                   !(current_state == STATE_HIGH && prev_state == STATE_LOW); // exclude wrap-around

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            case (current_state)
                STATE_HIGH:    {fr2, fr1, fr0, dfr} <= 4'b0000;
                STATE_MID_HIGH: {fr2, fr1, fr0, dfr} <= {1'b0, 1'b0, 1'b1, rising};
                STATE_MID_LOW:  {fr2, fr1, fr0, dfr} <= {1'b0, 1'b1, 1'b1, rising};
                STATE_LOW:     {fr2, fr1, fr0, dfr} <= 4'b1111;
                default:       {fr2, fr1, fr0, dfr} <= 4'b0000;
            endcase
        end
    end

endmodule