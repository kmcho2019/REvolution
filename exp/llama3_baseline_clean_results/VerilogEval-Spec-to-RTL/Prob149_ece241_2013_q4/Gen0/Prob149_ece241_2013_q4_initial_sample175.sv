module TopModule (
    input clk,
    input reset,
    input [2:0] s, // s[2] is highest sensor, s[0] is lowest
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin // active-high synchronous reset
        prev_s <= 3'b000; // reset to no sensors asserted
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        if (s == 3'b000) begin // water level below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else if (s == 3'b001) begin // water level between s[0] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s < s) begin
                dfr <= 1'b1; // increase flow rate
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b011) begin // water level between s[1] and s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s < s) begin
                dfr <= 1'b1; // increase flow rate
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b111) begin // water level above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
        prev_s <= s;
    end
end

endmodule