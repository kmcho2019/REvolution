module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Initialize outputs
always @(*) begin
    if (reset) begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else if (s == 3'b111) begin // Above s[2]
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b0;
        dfr = 1'b0;
    end else if (s == 3'b110) begin // Between s[2] and s[1]
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b1;
        dfr = 1'b0;
    end else if (s == 3'b100) begin // Between s[1] and s[0]
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b0;
    end else if (s == 3'b000) begin // Below s[0]
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end
end

// Update dfr based on previous level
reg [2:0] prev_s;
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

always @(*) begin
    if (reset) begin
        dfr <= 1'b1;
    end else if (s > prev_s) begin
        dfr <= 1'b1;
    end else begin
        dfr <= 1'b0;
    end
end

endmodule