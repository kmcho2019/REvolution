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
    wire water_rising;

    // Store previous sensor values
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Detect rising water level (any sensor newly covered)
    assign water_rising = ((s[0] & ~prev_s[0]) |  // Newly covered s[0]
                          (s[1] & ~prev_s[1]) |  // Newly covered s[1]
                          (s[2] & ~prev_s[2]));  // Newly covered s[2]

    // Output logic
    assign fr0 = reset ? 1'b1 : ~(&s);            // On unless all sensors covered
    assign fr1 = reset ? 1'b1 : (s < 3'b011);     // On when below s[2]
    assign fr2 = reset ? 1'b1 : (s == 3'b000);    // On only when no sensors covered
    assign dfr = reset ? 1'b1 : water_rising;     // On when water is rising

endmodule