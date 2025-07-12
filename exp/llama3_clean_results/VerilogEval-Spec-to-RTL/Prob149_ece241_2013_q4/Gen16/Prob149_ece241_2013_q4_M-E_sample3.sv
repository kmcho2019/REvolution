module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg [2:0] prev_s;
reg [1:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        prev_s <= 3'b000;
        prev_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        prev_state <= state;

        case (state)
            2'b00: begin
                if (~s[0] && ~s[1] && ~s[2]) begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[0] && ~s[1] && ~s[2]) begin
                    state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            2'b01: begin
                if (s[0] && ~s[1] && ~s[2]) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s[0] && s[1] && ~s[2]) begin
                    state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            2'b10: begin
                if (s[0] && s[1] && ~s[2]) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s[0] && s[1] && s[2]) begin
                    state <= 2'b11;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            end
            2'b11: begin
                if (s[0] && s[1] && s[2]) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase

        // check for rising or falling water level
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else if (s < prev_s) begin
            dfr <= 1'b0;
        end
    end
end

endmodule