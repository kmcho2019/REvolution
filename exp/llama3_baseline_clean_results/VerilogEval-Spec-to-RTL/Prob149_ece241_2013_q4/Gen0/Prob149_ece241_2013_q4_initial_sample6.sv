module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] curr_s;
reg [2:0] prev_s;
reg fr2_r, fr1_r, fr0_r, dfr_r;

always @(posedge clk) begin
    if (reset) begin
        curr_s <= 3'b000;
        prev_s <= 3'b000;
        fr2_r <= 1'b1;
        fr1_r <= 1'b1;
        fr0_r <= 1'b1;
        dfr_r <= 1'b1;
    end else begin
        prev_s <= curr_s;
        curr_s <= s;
        
        if (curr_s == 3'b111) begin // above s[2]
            fr2_r <= 1'b0;
            fr1_r <= 1'b0;
            fr0_r <= 1'b0;
            dfr_r <= 1'b0;
        end else if (curr_s == 3'b110) begin // between s[2] and s[1]
            fr2_r <= 1'b0;
            fr1_r <= 1'b0;
            fr0_r <= 1'b1;
            if (prev_s < curr_s) begin
                dfr_r <= 1'b1;
            end else begin
                dfr_r <= 1'b0;
            end
        end else if (curr_s == 3'b100) begin // between s[1] and s[0]
            fr2_r <= 1'b0;
            fr1_r <= 1'b1;
            fr0_r <= 1'b1;
            if (prev_s < curr_s) begin
                dfr_r <= 1'b1;
            end else begin
                dfr_r <= 1'b0;
            end
        end else begin // below s[0]
            fr2_r <= 1'b1;
            fr1_r <= 1'b1;
            fr0_r <= 1'b1;
            dfr_r <= 1'b1;
        end
    end
end

assign fr2 = fr2_r;
assign fr1 = fr1_r;
assign fr0 = fr0_r;
assign dfr = dfr_r;

endmodule