module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [3:0] count; // count consecutive ones, max 7+

    // Registers to hold conditions detected in previous cycle for Moore output timing
    reg disc_w, flag_w, err_w;

    always @(posedge clk) begin
        if (reset) begin
            count  <= 4'd0;
            disc   <= 1'b0;
            flag   <= 1'b0;
            err    <= 1'b0;
            disc_w <= 1'b0;
            flag_w <= 1'b0;
            err_w  <= 1'b0;
        end else begin
            // Update count of consecutive ones
            if (in)
                count <= (count < 7) ? count + 1 : 7; // saturate at 7+
            else
                count <= 4'd0;

            // Generate outputs based on previous cycle's count and input for one-cycle delayed Moore outputs
            disc   <= disc_w;
            flag   <= flag_w;
            err    <= err_w;

            // Determine output conditions based on current count and input (next cycle outputs)
            disc_w <= (count == 5) && (in == 1'b0);
            flag_w <= (count == 6) && (in == 1'b0);
            err_w  <= (count == 7);
        end
    end

endmodule