module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Count of consecutive ones (0 to 7+)
    reg [2:0] count;

    // Registered outputs for one cycle pulse
    reg disc_next, flag_next;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
            disc_next <= 1'b0;
            flag_next <= 1'b0;
        end else begin
            // Default clear output pulses
            disc <= disc_next;
            flag <= flag_next;

            // Error asserted when count saturates at 7 or more
            err <= (count == 3'd7);

            if (in) begin
                // Increment count, saturate at 7
                if (count < 3'd7)
                    count <= count + 3'd1;
                else
                    count <= 3'd7; // stay at max
                // No disc/flag generated when input=1
                disc_next <= 1'b0;
                flag_next <= 1'b0;
            end else begin
                // Input zero received: check count for special sequences
                disc_next <= (count == 3'd5);
                flag_next <= (count == 3'd6);
                // Reset count on zero input
                count <= 3'd0;
            end
        end
    end

endmodule