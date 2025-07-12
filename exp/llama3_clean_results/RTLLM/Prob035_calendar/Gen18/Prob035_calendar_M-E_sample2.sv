module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [5:0] state_Secs;
reg [5:0] state_Mins;
reg [4:0] state_Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state_Secs <= 6'd0;
        state_Mins <= 6'd0;
        state_Hours <= 5'd0;
    end else begin
        if (state_Secs == 6'd59) begin
            state_Secs <= 6'd0;
            if (state_Mins == 6'd59) begin
                state_Mins <= 6'd0;
                if (state_Hours == 5'd23) begin
                    state_Hours <= 5'd0;
                end else begin
                    state_Hours <= state_Hours + 5'd1;
                end
            end else begin
                state_Mins <= state_Mins + 6'd1;
            end
        end else begin
            state_Secs <= state_Secs + 6'd1;
        end
    end
end

assign Secs = state_Secs;
assign Mins = state_Mins;
assign Hours = state_Hours;

endmodule