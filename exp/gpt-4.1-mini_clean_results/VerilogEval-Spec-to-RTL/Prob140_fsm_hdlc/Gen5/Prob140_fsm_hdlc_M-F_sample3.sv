module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State: count of consecutive ones, saturating at 7+
    reg [2:0] count;

    // Detection signals combinationally derived from current count and input
    wire disc_detect = (count == 3'd5) && (in == 1'b0);  // after exactly 5 ones then 0
    wire flag_detect = (count == 3'd6) && (in == 1'b0);  // after exactly 6 ones then 0
    wire err_detect  = (count == 3'd7) && (in == 1'b1);  // 7 consecutive ones, next is 1 again

    // Registers to hold detection outputs for one cycle starting after detection
    reg disc_reg, flag_reg, err_reg;

    always @(posedge clk) begin
        if (reset) begin
            count    <= 3'd0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg  <= 1'b0;
            disc     <= 1'b0;
            flag     <= 1'b0;
            err      <= 1'b0;
        end else begin
            // Update count: increment if in=1 (saturate at 7), else reset to 0
            if (in)
                count <= (count < 3'd7) ? count + 3'd1 : 3'd7;
            else
                count <= 3'd0;

            // Register detection signals: outputs asserted one cycle after detection
            disc_reg <= disc_detect;
            flag_reg <= flag_detect;
            err_reg  <= err_detect;

            // Assign outputs from registered detection signals (Moore outputs)
            disc <= disc_reg;
            flag <= flag_reg;
            err  <= err_reg;
        end
    end

endmodule