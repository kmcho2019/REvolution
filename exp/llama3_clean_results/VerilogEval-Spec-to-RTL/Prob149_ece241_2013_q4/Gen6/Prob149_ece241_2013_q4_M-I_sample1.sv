module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        if (s[2] == 1'b1 && s[1] == 1'b1 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (s[2] == 1'b1 && s[1] == 1'b1 && s[0] == 1'b0) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s[2] == 1'b1 && s[1] == 1'b0 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s[2] == 1'b1 && s[1] == 1'b0 && s[0] == 1'b0) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else if (s[2] == 1'b0 && s[1] == 1'b1 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s[2] == 1'b0 && s[1] == 1'b1 && s[0] == 1'b0) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else if (s[2] == 1'b0 && s[1] == 1'b0 && s[0] == 1'b1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        
        if ((s[0] == 1'b1 && prev_s[0] == 1'b0) || (s[1] == 1'b1 && prev_s[1] == 1'b0) || (s[2] == 1'b1 && prev_s[2] == 1'b0)) begin
            dfr <= 1'b1;
        end else if ((s[0] == 1'b0 && prev_s[0] == 1'b1) || (s[1] == 1'b0 && prev_s[1] == 1'b1) || (s[2] == 1'b0 && prev_s[2] == 1'b1)) begin
            dfr <= 1'b0;
        end else begin
            dfr <= dfr;
        end
    end
end

endmodule