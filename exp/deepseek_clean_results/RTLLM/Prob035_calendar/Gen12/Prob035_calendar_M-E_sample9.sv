module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// State encoding (one-hot)
localparam S_NORMAL = 3'b001;
localparam S_MIN_INC = 3'b010;
localparam S_HOUR_INC = 3'b100;
reg [2:0] current_state, next_state;

// Rollover detection (parallel)
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 6'd23);

// Next value prediction (combinational)
wire [5:0] next_sec = sec_max ? 6'd0 : (Secs + 6'd1);
wire [5:0] next_min = min_max ? 6'd0 : (Mins + 6'd1);
wire [5:0] next_hour = hour_max ? 6'd0 : (Hours + 6'd1);

// State transition logic
always @(*) begin
    case (current_state)
        S_NORMAL: next_state = sec_max ? S_MIN_INC : S_NORMAL;
        S_MIN_INC: next_state = min_max ? S_HOUR_INC : S_NORMAL;
        S_HOUR_INC: next_state = S_NORMAL;
        default: next_state = S_NORMAL;
    endcase
end

// Clock gating signals
wire update_sec = (current_state == S_NORMAL) || RST;
wire update_min = (current_state == S_MIN_INC) || RST;
wire update_hour = (current_state == S_HOUR_INC) || RST;

// Sequential logic with conditional updates
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        current_state <= S_NORMAL;
    end else begin
        current_state <= next_state;
        
        // Conditional updates
        if (update_sec) Secs <= next_sec;
        if (update_min) Mins <= next_min;
        if (update_hour) Hours <= next_hour;
    end
end

// Output validation (prevent overflow)
always @(*) begin
    if (Hours > 6'd23) Hours = 6'd23;
    if (Mins > 6'd59) Mins = 6'd59;
    if (Secs > 6'd59) Secs = 6'd59;
end

endmodule