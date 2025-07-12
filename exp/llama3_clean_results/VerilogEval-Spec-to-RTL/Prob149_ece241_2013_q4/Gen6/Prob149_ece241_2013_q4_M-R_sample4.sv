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

// Combinational logic to determine the output signals
always @(*) begin
    if (~s[2] && ~s[1] && ~s[0]) begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
    end else if (~s[2] && ~s[1] && s[0]) begin
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
    end else if (~s[2] && s[1] && s[0]) begin
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
    end else if (~s[2] && s[1] && ~s[0]) begin
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b1;
    end else begin
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b0;
    end
end

// Sequential logic to track the previous sensor state and determine 'dfr'
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
        prev_s <= s;
    end
end

endmodule