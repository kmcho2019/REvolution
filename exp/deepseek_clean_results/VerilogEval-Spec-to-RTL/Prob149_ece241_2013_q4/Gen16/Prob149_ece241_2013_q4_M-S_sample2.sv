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
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor values for rising edge detection
            prev_s <= s;

            // Nominal flow outputs
            fr0 <= (s != 3'b111);
            fr1 <= (s == 3'b100 || s == 3'b000);
            fr2 <= (s == 3'b000);

            // Supplemental flow (rising water detected)
            dfr <= (s > prev_s);
        end
    end

endmodule