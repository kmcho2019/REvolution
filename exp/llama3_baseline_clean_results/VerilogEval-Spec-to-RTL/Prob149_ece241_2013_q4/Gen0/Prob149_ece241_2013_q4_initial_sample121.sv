module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;
reg [2:0] prevState;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // no sensors asserted
        prevState <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prevState <= s;
        case (s)
            3'b111: begin // above s[2]
                state <= 3'b111;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b110: begin // between s[2] and s[1]
                state <= 3'b110;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (s > prevState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b100: begin // between s[1] and s[0]
                state <= 3'b100;
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (s > prevState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b000: begin // below s[0]
                state <= 3'b000;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            default: begin
                state <= state;
                fr2 <= fr2;
                fr1 <= fr1;
                fr0 <= fr0;
                dfr <= dfr;
            end
        endcase
    end
end

endmodule