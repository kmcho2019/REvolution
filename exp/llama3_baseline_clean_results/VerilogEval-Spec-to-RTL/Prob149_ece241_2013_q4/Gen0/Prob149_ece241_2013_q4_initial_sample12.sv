module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s; // previous state of sensors

always @ (posedge clk) begin
    if (reset) begin // reset to initial state
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s; // update previous state

        if (s[2] == 1'b1 && s[1] == 1'b1 && s[0] == 1'b1) begin // above highest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[2] == 1'b0 && s[1] == 1'b1 && s[0] == 1'b1) begin // between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s[0] == 1'b0 || prev_s[1] == 1'b0) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[2] == 1'b0 && s[1] == 1'b0 && s[0] == 1'b1) begin // between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s[0] == 1'b0) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[2] == 1'b0 && s[1] == 1'b0 && s[0] == 1'b0) begin // below lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

endmodule