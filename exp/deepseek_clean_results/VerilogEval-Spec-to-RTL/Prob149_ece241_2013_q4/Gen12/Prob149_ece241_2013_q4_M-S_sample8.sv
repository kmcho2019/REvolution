module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;
    wire level_rising = (s > prev_s);

    // Output assignments based directly on sensor values
    assign fr0 = ~(&s);  // Not all sensors active
    assign fr1 = (s == 3'b000) || (s == 3'b001);  // Below s0 or between s0-s1
    assign fr2 = (s == 3'b000);  // Only below s0
    assign dfr = level_rising;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

endmodule