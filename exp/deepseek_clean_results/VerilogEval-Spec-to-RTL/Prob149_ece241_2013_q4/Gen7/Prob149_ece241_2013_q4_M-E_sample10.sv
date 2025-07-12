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
    wire rising;

    // Store previous sensor values
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Detect any sensor becoming active (rising water level)
    assign rising = |(s & ~prev_s);

    // Output logic based on current sensor readings
    assign fr2 = (s == 3'b000);                   // Below s[0]
    assign fr1 = (s == 3'b000) || (s == 3'b001); // Below s[0] or between s[1]-s[0]
    assign fr0 = (s != 3'b111);                  // Not above s[2]
    assign dfr = rising && (s != 3'b111);        // Rising level and not at max

    // Override outputs during reset
    assign {fr2, fr1, fr0, dfr} = reset ? 4'b1111 : {fr2, fr1, fr0, dfr};

endmodule