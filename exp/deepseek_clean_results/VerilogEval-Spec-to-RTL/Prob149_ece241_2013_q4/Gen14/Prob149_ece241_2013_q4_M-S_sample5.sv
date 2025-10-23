module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state for dfr calculation
            prev_s <= s;

            // Nominal flow outputs
            fr0 <= ~s[0] | (s[0] & ~s[1]);
            fr1 <= ~s[0] | (s[0] & ~s[1]);
            fr2 <= ~s[0] & ~s[1] & ~s[2];

            // Supplemental flow (rising water)
            dfr <= (s > prev_s);
        end
    end

endmodule