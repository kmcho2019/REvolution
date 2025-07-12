module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
        state <= 2'd0; // Reset state
    end else begin
        case (state)
            2'd0: begin // Reset state, do nothing
                if (Secs!= 6'd0 || Mins!= 6'd0 || Hours!= 5'd0) begin
                    Secs <= 6'd0;
                    Mins <= 6'd0;
                    Hours <= 5'd0;
                end
                state <= 2'd1; // Move to increment_seconds state
            end
            2'd1: begin // Increment seconds state
                if (Secs == 6'd59) begin
                    Secs <= 6'd0;
                    if (Mins == 6'd59) begin
                        Mins <= 6'd0;
                        if (Hours == 5'd23) begin
                            Hours <= 5'd0;
                        end else begin
                            Hours <= Hours + 1'd1;
                        end
                    end else begin
                        Mins <= Mins + 1'd1;
                    end
                end else begin
                    Secs <= Secs + 1'd1;
                end
            end
            default: begin
                // This state should not be reached, handle as reset
                Secs <= 6'd0;
                Mins <= 6'd0;
                Hours <= 5'd0;
                state <= 2'd0;
            end
        endcase
    end
end

endmodule