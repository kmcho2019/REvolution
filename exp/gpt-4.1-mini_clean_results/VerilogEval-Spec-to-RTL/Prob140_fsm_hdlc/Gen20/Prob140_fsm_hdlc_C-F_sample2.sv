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

    // Combinational logic to determine next state and outputs
    always @(*) begin
        // Default assignments
        count_next = count;
        disc_next  = 1'b0;
        flag_next  = 1'b0;
        err_next   = 1'b0;

        if (in) begin
            // Increment counter with saturation at 7
            count_next = (count < 3'd7) ? (count + 3'd1) : 3'd7;

            // Error if counter was 6 or 7 before increment (7 or more ones)
            err_next = (count >= 3'd6);
        end else begin
            // If zero after 5 ones: discard stuffed zero
            if (count == 3'd5)
                disc_next = 1'b1;
            // If zero after 6 ones: flag pattern
            else if (count == 3'd6)
                flag_next = 1'b1;

            // Reset counter on zero input
            count_next = 3'd0;
        end
    end

    // Sequential logic to update count and outputs synchronously
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