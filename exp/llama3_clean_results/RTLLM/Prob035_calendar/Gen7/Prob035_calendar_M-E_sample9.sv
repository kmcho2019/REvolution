module calendar (
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [1:0] state;
reg [5:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 2'd0; // idle state
        counter <= 6'd0;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        case (state)
            2'd0: begin // idle state
                counter <= counter + 1'd1;
                Secs <= counter;
                if (counter == 6'd59) begin
                    state <= 2'd1; // increment_seconds state
                end
            end
            2'd1: begin // increment_seconds state
                counter <= 6'd0;
                Secs <= 6'd0;
                Mins <= Mins + 1'd1;
                if (Mins == 6'd59) begin
                    state <= 2'd2; // increment_minutes_hours state
                end else begin
                    state <= 2'd0; // idle state
                end
            end
            2'd2: begin // increment_minutes_hours state
                Mins <= 6'd0;
                Hours <= Hours + 1'd1;
                if (Hours == 5'd23) begin
                    Hours <= 5'd0;
                end
                state <= 2'd0; // idle state
            end
        endcase
    end
end

endmodule