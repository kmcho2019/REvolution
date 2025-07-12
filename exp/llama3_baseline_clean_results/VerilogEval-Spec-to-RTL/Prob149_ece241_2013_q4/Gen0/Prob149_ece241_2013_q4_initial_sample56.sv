module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(*) begin
    if (reset) begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else if (s[2]) begin
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b0;
        dfr = 1'b0;
    end else if (s[1]) begin
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b1;
        if (prev_s < s) dfr = 1'b1;
        else dfr = 1'b0;
    end else if (s[0]) begin
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
        if (prev_s < s) dfr = 1'b1;
        else dfr = 1'b0;
    end else begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

endmodule