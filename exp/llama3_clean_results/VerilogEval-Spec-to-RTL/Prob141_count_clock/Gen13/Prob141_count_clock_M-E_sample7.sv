module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] state;
reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

localparam S_IDLE = 4'd0;
localparam S_INCREMENT_SECONDS = 4'd1;
localparam S_INCREMENT_MINUTES = 4'd2;
localparam S_INCREMENT_HOURS = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        seconds <= 0;
        minutes <= 0;
        hours <= 12; // 12:00:00 AM
        pm <= 0; // AM
    end else if (ena) begin
        case (state)
            S_IDLE: begin
                state <= S_INCREMENT_SECONDS;
            end
            S_INCREMENT_SECONDS: begin
                seconds <= seconds + 1;
                if (seconds == 60) begin
                    seconds <= 0;
                    state <= S_INCREMENT_MINUTES;
                end
            end
            S_INCREMENT_MINUTES: begin
                minutes <= minutes + 1;
                if (minutes == 60) begin
                    minutes <= 0;
                    state <= S_INCREMENT_HOURS;
                end else begin
                    state <= S_IDLE;
                end
            end
            S_INCREMENT_HOURS: begin
                hours <= hours + 1;
                if (hours == 13) begin
                    hours <= 1; // 1:00:00 AM
                    pm <= 0; // AM
                end else if (hours == 12) begin
                    pm <= 1'b1; // PM
                end else if (hours > 12) begin
                    hours <= hours - 12;
                    pm <= 1'b1; // PM
                end
                state <= S_IDLE;
            end
            default: state <= S_IDLE;
        endcase
    end
end

always @(*) begin
    hh = {4'b0, hours};
    mm = {4'b0, minutes};
    ss = {4'b0, seconds};
end

endmodule