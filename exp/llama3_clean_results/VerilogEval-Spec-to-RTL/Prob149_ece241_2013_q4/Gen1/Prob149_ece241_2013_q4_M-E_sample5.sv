module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] currentState, nextState;
reg [2:0] prev_s;

always @(*) begin
    case (s)
        3'b111: begin // Above s[2]
            nextState = 2'b00;
        end
        3'b110: begin // Between s[2] and s[1]
            nextState = 2'b01;
        end
        3'b100, 3'b101, 3'b111: begin // Between s[1] and s[0]
            nextState = 2'b10;
        end
        default: begin // Below s[0]
            nextState = 2'b11;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= 2'b11;
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        currentState <= nextState;
        prev_s <= s;
        
        case (currentState)
            2'b00: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (nextState > currentState);
            end
            2'b10: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (nextState > currentState);
            end
            2'b11: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (nextState > currentState);
            end
        endcase
    end
end

endmodule