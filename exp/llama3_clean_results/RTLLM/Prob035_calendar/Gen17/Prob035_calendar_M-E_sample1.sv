module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [2:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // S0: initial state
        Secs <= 6'b0;
        Mins <= 6'b0;
        Hours <= 5'b0;
    end else begin
        case (state)
            3'b000: begin // S0: initial state
                state <= 3'b001; // transition to S1: normal counting
                Secs <= Secs + 1'b1;
            end
            3'b001: begin // S1: normal counting
                if (Secs == 6'd59) begin
                    if (Mins == 6'd59) begin
                        if (Hours == 5'd23) begin
                            state <= 3'b011; // transition to S3: hours wrap-around
                            Secs <= 6'b0;
                            Mins <= 6'b0;
                            Hours <= 5'b0;
                        end else begin
                            state <= 3'b010; // transition to S2: minutes wrap-around
                            Secs <= 6'b0;
                            Mins <= 6'b0;
                            Hours <= Hours + 1'b1;
                        end
                    end else begin
                        state <= 3'b001; // stay in S1: normal counting
                        Secs <= 6'b0;
                        Mins <= Mins + 1'b1;
                    end
                end else begin
                    state <= 3'b001; // stay in S1: normal counting
                    Secs <= Secs + 1'b1;
                end
            end
            3'b010: begin // S2: minutes wrap-around
                state <= 3'b001; // transition to S1: normal counting
                Secs <= Secs + 1'b1;
            end
            3'b011: begin // S3: hours wrap-around
                state <= 3'b001; // transition to S1: normal counting
                Secs <= Secs + 1'b1;
            end
            default: begin
                state <= 3'b000; // transition to S0: initial state
                Secs <= 6'b0;
                Mins <= 6'b0;
                Hours <= 5'b0;
            end
        endcase
    end
end

endmodule