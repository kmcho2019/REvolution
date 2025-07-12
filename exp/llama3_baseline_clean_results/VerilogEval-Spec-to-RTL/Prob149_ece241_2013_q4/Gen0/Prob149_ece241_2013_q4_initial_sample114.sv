module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// State encoding
// 00: below s[0]
// 01: between s[0] and s[1]
// 10: between s[1] and s[2]
// 11: above s[2]
reg [1:0] state;
reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        state <= 2'b00;
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        case (state)
            2'b00: begin
                if (s[0]) begin
                    state <= 2'b01;
                end
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (s[0] && !prev_s[0]) ? 1'b1 : 1'b0;
            end
            2'b01: begin
                if (s[1]) begin
                    state <= 2'b10;
                end else if (!s[0]) begin
                    state <= 2'b00;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (s[1] && !prev_s[1]) ? 1'b1 : 1'b0;
            end
            2'b10: begin
                if (s[2]) begin
                    state <= 2'b11;
                end else if (!s[1]) begin
                    state <= 2'b01;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (s[2] && !prev_s[2]) ? 1'b1 : 1'b0;
            end
            2'b11: begin
                if (!s[2]) begin
                    state <= 2'b10;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule