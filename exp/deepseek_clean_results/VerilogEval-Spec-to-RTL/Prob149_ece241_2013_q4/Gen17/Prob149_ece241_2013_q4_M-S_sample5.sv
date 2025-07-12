module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

    reg [2:0] prev_s;  // Previous sensor state

    // Combinational flow rate outputs
    assign fr0 = ~s[2];  // On unless above s[2]
    assign fr1 = ~(|s[1:0]);  // On when below s[1] (s[1] and s[0] not asserted)
    assign fr2 = ~(|s);  // Only when all sensors off (below s[0])

    always @(posedge clk) begin
        if (reset) begin
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Determine highest asserted sensor bit for current and previous states
            dfr <= (s[2] & ~prev_s[2]) ||  // Rising to above s[2]
                   (s[1] & ~prev_s[1] & ~s[2]) ||  // Rising to between s[2]-s[1]
                   (s[0] & ~prev_s[0] & ~(|s[2:1]));  // Rising to between s[1]-s[0]

            prev_s <= s;
        end
    end

endmodule