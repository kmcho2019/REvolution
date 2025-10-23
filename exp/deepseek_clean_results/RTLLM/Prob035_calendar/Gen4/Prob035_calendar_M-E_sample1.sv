module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// State encoding
typedef enum logic [1:0] {
    COUNT_SEC,
    COUNT_MIN,
    COUNT_HOUR
} count_state_t;

count_state_t state, next_state;

// Next value computation
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;
wire [5:0] next_min = (Mins == 6'd59) ? 6'd0 : Mins + 6'd1;
wire [5:0] next_hour = (Hours == 6'd23) ? 6'd0 : Hours + 6'd1;

// State transition logic
always_comb begin
    case (state)
        COUNT_SEC: next_state = (Secs == 6'd59) ? COUNT_MIN : COUNT_SEC;
        COUNT_MIN: next_state = (Mins == 6'd59) ? COUNT_HOUR : COUNT_SEC;
        COUNT_HOUR: next_state = COUNT_SEC;
        default: next_state = COUNT_SEC;
    endcase
end

// Counter update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= COUNT_SEC;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        state <= next_state;
        
        case (state)
            COUNT_SEC: begin
                Secs <= next_sec;
                if (next_state == COUNT_MIN) begin
                    Mins <= next_min;
                end
            end
            COUNT_MIN: begin
                if (next_state == COUNT_HOUR) begin
                    Hours <= next_hour;
                end
            end
            default: begin
                // No additional updates needed
            end
        endcase
    end
end

endmodule