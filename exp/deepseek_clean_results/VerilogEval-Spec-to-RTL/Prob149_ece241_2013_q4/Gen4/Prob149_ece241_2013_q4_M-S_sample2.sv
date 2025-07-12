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

    // Detect rising level (current level higher than previous)
    wire level_rising = (s > prev_s);

    // Output logic (combinational)
    assign fr0 = reset ? 1'b1 : ~(&s);                // On unless all sensors on
    assign fr1 = reset ? 1'b1 : (s == 3'b000 || s == 3'b001);
    assign fr2 = reset ? 1'b1 : (s == 3'b000);
    assign dfr = reset ? 1'b1 : level_rising;

endmodule