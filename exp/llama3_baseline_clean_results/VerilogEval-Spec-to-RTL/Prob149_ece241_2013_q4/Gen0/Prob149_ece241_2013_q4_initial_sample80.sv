module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state;
reg [1:0] nextState;
reg [2:0] prev_s;

always @(*) begin
    case (state)
        2'b00: begin // Below s[0]
            if (s[0]) begin
                nextState = 2'b01;
            end else begin
                nextState = 2'b00;
            end
        end
        2'b01: begin // Between s[0] and s[1]
            if (s[1]) begin
                nextState = 2'b10;
            end else if (!s[0]) begin
                nextState = 2'b00;
            end else begin
                nextState = 2'b01;
            end
        end
        2'b10: begin // Between s[1] and s[2]
            if (s[2]) begin
                nextState = 2'b11;
            end else if (!s[1]) begin
                nextState = 2'b01;
            end else begin
                nextState = 2'b10;
            end
        end
        2'b11: begin // Above s[2]
            if (!s[2]) begin
                nextState = 2'b10;
            end else begin
                nextState = 2'b11;
            end
        end
        default: begin
            nextState = 2'b00;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= nextState;
        prev_s <= s;
        case (state)
            2'b00: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (s[0] &&!prev_s[0]);
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (s[1] &&!prev_s[1]);
            end
            2'b11: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule