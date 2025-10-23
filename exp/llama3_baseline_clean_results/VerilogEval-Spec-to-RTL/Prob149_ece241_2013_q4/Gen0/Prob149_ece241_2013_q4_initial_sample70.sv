module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s; // previous sensor value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // reset state machine to state equivalent to water level being low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000; // no sensors asserted
    end else begin
        // check current sensor value and decide flow rate
        if (s == 3'b111) begin
            // water level above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin
            // water level between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s == 3'b111 || prev_s == 3'b000) begin
                dfr <= 1'b0;
            end else begin
                dfr <= 1'b0; // no need to increase flow rate
            end
        end else if (s == 3'b100) begin
            // water level between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s == 3'b110 || prev_s == 3'b000) begin
                dfr <= 1'b1; // increase flow rate
            end else begin
                dfr <= 1'b0;
            end
        end else begin
            // water level below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1; // maximum flow rate
        end

        // update previous sensor value
        prev_s <= s;
    end
end

endmodule