module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else begin
        if (s == 3'b111) begin // Water level above s[2]
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end else if (s == 3'b110) begin // Water level between s[2] and s[1]
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = 1'b0;
        end else if (s == 3'b100) begin // Water level between s[1] and s[0]
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b0;
        end else if (s == 3'b000) begin // Water level below s[0]
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else if (s == 3'b010 || s == 3'b001) begin // Water level between s[1] and s[0] or only s[0]
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b0;
        end
    end
end

endmodule