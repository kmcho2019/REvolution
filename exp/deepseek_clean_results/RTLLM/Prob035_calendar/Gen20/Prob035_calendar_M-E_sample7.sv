module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// State encoding (one-hot with gray transition)
localparam [2:0] ST_SEC  = 3'b001,
                 ST_MIN  = 3'b011,
                 ST_HOUR = 3'b010;

reg [2:0] state, next_state;

// Next value computation (combinational)
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;
wire [5:0] next_min = (Mins == 6'd59) ? 6'd0 : Mins + 6'd1;
wire [5:0] next_hour = (Hours == 6'd23) ? 6'd0 : Hours + 6'd1;

// State transition logic
always @(*) begin
    case (state)
        ST_SEC:  next_state = (Secs == 6'd59) ? ST_MIN : ST_SEC;
        ST_MIN:  next_state = (Mins == 6'd59) ? ST_HOUR : ST_SEC;
        ST_HOUR: next_state = ST_SEC;
        default: next_state = ST_SEC;
    endcase
end

// Sequential update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        state <= ST_SEC;
    end else begin
        state <= next_state;
        
        // Always update seconds
        Secs <= next_sec;
        
        // Conditional updates
        case (next_state)
            ST_MIN:  Mins <= next_min;
            ST_HOUR: Hours <= next_hour;
        endcase
    end
end

endmodule