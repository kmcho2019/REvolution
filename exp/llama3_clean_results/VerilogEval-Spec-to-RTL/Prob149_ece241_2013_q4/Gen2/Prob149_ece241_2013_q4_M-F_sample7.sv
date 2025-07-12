module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] currentState;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= 2'b11;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b111: begin // Above s[2]
                currentState <= 2'b00;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b110: begin // Between s[2] and s[1]
                currentState <= 2'b01;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (currentState == 2'b00);
            end
            3'b101, 3'b100: begin // Between s[1] and s[0]
                currentState <= 2'b10;
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (currentState == 2'b01 || currentState == 2'b00);
            end
            default: begin // Below s[0]
                currentState <= 2'b11;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule