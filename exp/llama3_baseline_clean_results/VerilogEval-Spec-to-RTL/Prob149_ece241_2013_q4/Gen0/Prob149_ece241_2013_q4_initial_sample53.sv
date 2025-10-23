module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg [1:0] prev_state;

always @(*) begin
    case(state)
        2'b00: begin // Below s[0]
            if (s[0] == 1'b1) begin
                state <= 2'b01;
                prev_state <= 2'b00;
            end
            else begin
                state <= 2'b00;
                prev_state <= 2'b00;
            end
        end
        2'b01: begin // Between s[0] and s[1]
            if (s[1] == 1'b1) begin
                state <= 2'b10;
                prev_state <= 2'b01;
            end
            else if (s[0] == 1'b0) begin
                state <= 2'b00;
                prev_state <= 2'b01;
            end
            else begin
                state <= 2'b01;
                prev_state <= 2'b01;
            end
        end
        2'b10: begin // Between s[1] and s[2]
            if (s[2] == 1'b1) begin
                state <= 2'b11;
                prev_state <= 2'b10;
            end
            else if (s[1] == 1'b0) begin
                state <= 2'b01;
                prev_state <= 2'b10;
            end
            else begin
                state <= 2'b10;
                prev_state <= 2'b10;
            end
        end
        2'b11: begin // Above s[2]
            if (s[2] == 1'b0) begin
                state <= 2'b10;
                prev_state <= 2'b11;
            end
            else begin
                state <= 2'b11;
                prev_state <= 2'b11;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= 2'b00;
        prev_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end
    else begin
        case(state)
            2'b00: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b01: begin // Between s[0] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == 2'b00) begin
                    dfr <= 1'b1;
                end
                else begin
                    dfr <= 1'b0;
                end
            end
            2'b10: begin // Between s[1] and s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_state == 2'b01) begin
                    dfr <= 1'b1;
                end
                else begin
                    dfr <= 1'b0;
                end
            end
            2'b11: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule