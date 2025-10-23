module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] previous_s;
reg [2:0] current_s;

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        previous_s <= 3'b000;
        current_s <= 3'b000;
    end else begin
        previous_s <= current_s;
        current_s <= s;
        
        if (s == 3'b111) begin // Above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin // Between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (previous_s < current_s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b100) begin // Between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (previous_s < current_s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b000) begin // Below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
    end
end

endmodule