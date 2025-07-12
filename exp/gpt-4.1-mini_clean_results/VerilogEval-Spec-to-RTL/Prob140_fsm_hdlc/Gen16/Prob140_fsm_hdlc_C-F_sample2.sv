module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit saturating counter tracking consecutive ones (0 to 7)
    reg [2:0] count, next_count;

    // Next cycle outputs
    reg disc_next, flag_next, err_next;

    // Combinational next-state and output logic
    always @(*) begin
        // Default assignments
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;
        next_count = count;

        if (in) begin
            // Increment count if less than 7, else saturate at 7
            if (count < 3'd7)
                next_count = count + 3'd1;
            else
                next_count = 3'd7;

            // Error if count already 6 or 7 and input = 1 (7 or more consecutive ones)
            if (count >= 3'd6)
                err_next = 1'b1;
        end else begin
            // Input zero resets count
            next_count = 3'd0;

            // Disc: zero after exactly 5 consecutive ones (0111110)
            if (count == 3'd5)
                disc_next = 1'b1;
            // Flag: zero after exactly 6 consecutive ones (01111110)
            else if (count == 3'd6)
                flag_next = 1'b1;
        end
    end

    // Clock enable for counter update to reduce toggling when saturated at 7 and in=1
    wire count_update_en = (in && (count < 3'd7)) || (!in);

    // Sequential logic: register count and outputs with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            if (count_update_en)
                count <= next_count;
            // If saturated at 7 and in=1, hold count to reduce toggling

            disc <= disc_next;
            flag <= flag_next;
            err  <= err_next;
        end
    end

endmodule