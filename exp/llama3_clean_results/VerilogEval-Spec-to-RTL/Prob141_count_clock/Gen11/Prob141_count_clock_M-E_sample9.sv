module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [1:0] state;
reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'd0;
        hours <= 4'd12;
        minutes <= 6'd0;
        seconds <= 6'd0;
    end else if (ena) begin
        case (state)
            2'd0: begin // seconds increment state
                if (seconds == 6'd59) begin
                    state <= 2'd1;
                    seconds <= 6'd0;
                end else begin
                    seconds <= seconds + 1;
                end
            end
            2'd1: begin // minutes increment state
                if (minutes == 6'd59) begin
                    state <= 2'd2;
                    minutes <= 6'd0;
                end else begin
                    minutes <= minutes + 1;
                    state <= 2'd0;
                end
            end
            2'd2: begin // hours increment state
                if (hours == 4'd12) begin
                    hours <= 4'd1;
                end else begin
                    hours <= hours + 1;
                end
                state <= 2'd0;
            end
            default: state <= 2'd0;
        endcase
    end
end

assign pm = (hours >= 4'd6) ? 1'b1 : 1'b0;
assign hh = {4'd0, hours};
assign mm = {2'd0, minutes};
assign ss = {2'd0, seconds};

endmodule