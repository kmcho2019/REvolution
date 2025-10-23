module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit saturating counter for consecutive ones (0 to 7)
    reg [2:0] count, count_next;

    // Next-cycle outputs (Moore FSM outputs registered)
    reg disc_next, flag_next, err_next;

    // Combinational logic: compute next count and next outputs based on current count and input
    always @(*) begin
        // Default next outputs deasserted
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        // Default next count same as current (hold)
        count_next = count;

        if (in) begin
            // Increment count with saturation at 7
            if (count < 3'd7)
                count_next = count + 3'd1;
            else
                count_next = 3'd7;

            // Error condition: 7 or more consecutive ones
            // This means previous count >= 6 and input is 1 (this cycle count would be >=7)
            if (count >= 3'd6)
                err_next = 1'b1;
        end else begin
            // Input zero resets count
            count_next = 3'd0;

            // If count is 5 and input is zero, it's a stuffed zero to discard
            if (count == 3'd5)
                disc_next = 1'b1;
            // If count is 6 and input is zero, it indicates a flag pattern
            else if (count == 3'd6)
                flag_next = 1'b1;
        end
    end

    // Sequential logic: update count and outputs at positive clock edge with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            count <= count_next;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule