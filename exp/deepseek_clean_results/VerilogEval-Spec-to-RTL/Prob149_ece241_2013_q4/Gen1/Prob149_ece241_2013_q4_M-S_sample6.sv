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

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Output logic based directly on sensors
    assign fr0 = ~s[2] | ~s[1] | ~s[0];  // On unless all sensors are 1
    assign fr1 = ~s[2] | ~s[1];          // On unless s[2] and s[1] are 1
    assign fr2 = ~s[2];                  // On unless s[2] is 1

    // Supplemental flow when water level was lower before (rising)
    assign dfr = (s > prev_s);

    // Override outputs during reset
    assign {fr2, fr1, fr0, dfr} = reset ? 4'b1111 : {fr2, fr1, fr0, dfr};

endmodule