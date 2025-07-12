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

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        state <= 2'b11;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            2'b00: begin // Above s[2]
                if (~s[2] && s[1] && s[0]) begin
                    state <= 2'b01;
                end else if (~s[2] && ~s[1] && s[0]) begin
                    state <= 2'b10;
                end else if (~s[2] && ~s[1] && ~s[0]) begin
                    state <= 2'b11;
                end
            end
            2'b01: begin // Between s[2] and s[1]
                if (s[2] && s[1] && s[0]) begin
                    state <= 2'b00;
                end else if (~s[2] && ~s[1] && s[0]) begin
                    state <= 2'b10;
                end else if (~s[2] && ~s[1] && ~s[0]) begin
                    state <= 2'b11;
                end
            end
            2'b10: begin // Between s[1] and s[0]
                if (s[2] && s[1] && s[0]) begin
                    state <= 2'b00;
                end else if (~s[2] && s[1] && s[0]) begin
                    state <= 2'b01;
                end else if (~s[2] && ~s[1] && ~s[0]) begin
                    state <= 2'b11;
                end
            end
            2'b11: begin // Below s[0]
                if (s[2] && s[1] && s[0]) begin
                    state <= 2'b00;
                end else if (~s[2] && s[1] && s[0]) begin
                    state <= 2'b01;
                end else if (~s[2] && ~s[1] && s[0]) begin
                    state <= 2'b10;
                end
            end
        endcase

        case (state)
            2'b00: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b11: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase

        // Check for rising edge on sensor signals to assert dfr
        if ((~s[2] && ~s[1] && ~s[0]) && (state == 2'b11)) begin
            dfr <= 1'b1;
        end else if ((s[2] && s[1] && s[0]) && (state == 2'b00)) begin
            dfr <= 1'b0;
        end else if ((~s[2] && s[1] && s[0]) && (state == 2'b01)) begin
            dfr <= 1'b0;
        end else if ((~s[2] && ~s[1] && s[0]) && (state == 2'b10)) begin
            dfr <= 1'b1;
        end
    end
end

endmodule