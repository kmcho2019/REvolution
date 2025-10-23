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

    // Track previous sensor readings
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Output logic - directly from specification
    assign fr0 = ~(&s);                     // On unless all sensors are 1
    assign fr1 = (s == 3'b001) || (s == 3'b000); // Only s[0] or none
    assign fr2 = (s == 3'b000);             // Only when no sensors

    // dfr is 1 when water level is rising (current > previous)
    assign dfr = (s > prev_s) && ~reset;

endmodule