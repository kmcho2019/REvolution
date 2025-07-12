module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Sensor Interpretation Module
reg [2:0] prev_s;
reg rising, falling;

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

always @(*) begin
    rising = (s > prev_s);
    falling = (s < prev_s);
end

// Flow Rate Calculation Module
always @(*) begin
    if (s[2]) begin
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b0;
    end else if (s[1]) begin
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b1;
    end else if (s[0]) begin
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
    end else begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
    end
end

// Control Logic Module for dfr
always @(posedge clk) begin
    if (reset) begin
        dfr <= 1'b1;
    end else begin
        if (rising) begin
            dfr <= 1'b1;
        end else if (falling) begin
            dfr <= 1'b0;
        end
    end
end

endmodule