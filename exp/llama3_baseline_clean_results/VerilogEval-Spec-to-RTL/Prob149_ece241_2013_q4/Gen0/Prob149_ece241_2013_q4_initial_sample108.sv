module TopModule(
    input clk,
    input reset,
    input [2:0] s,  // s[2] is the highest sensor, s[0] is the lowest sensor
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;  // previous sensor value

always @(posedge clk) begin
    if (reset) begin
        // reset state machine to a state equivalent to if the water level had been low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;  // no sensors asserted
    end else begin
        if (s == 3'b111) begin  // water level above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b011) begin  // water level between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (prev_s < s);  // check if water level is rising
        end else if (s == 3'b001) begin  // water level between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_s < s);  // check if water level is rising
        end else begin  // water level below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
        prev_s <= s;  // update previous sensor value
    end
end

endmodule