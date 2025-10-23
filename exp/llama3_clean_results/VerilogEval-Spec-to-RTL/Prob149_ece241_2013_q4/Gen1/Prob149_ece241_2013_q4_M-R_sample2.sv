module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset state: all outputs asserted, no sensors asserted
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

always @(*) begin
    if (s == 3'b111) begin
        // Above s[2]: no flow
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b0;
        dfr = 1'b0;
    end else if (s == 3'b011) begin
        // Between s[2] and s[1]: nominal flow rate fr0
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b1;
        // Check if previous level was lower than current level
        if ((prev_s < s) && (prev_s!= 3'b000)) begin
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else if (s == 3'b001) begin
        // Between s[1] and s[0]: nominal flow rate fr0, fr1
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
        // Check if previous level was lower than current level
        if ((prev_s < s) && (prev_s!= 3'b000)) begin
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else begin
        // Below s[0]: maximum flow rate
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end
end

endmodule