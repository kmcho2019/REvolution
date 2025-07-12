module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit saturating counter of consecutive ones (0 to 7)
    reg [2:0] count, count_next;

    // Next-cycle outputs (Moore FSM outputs registered)
    reg disc_next, flag_next, err_next;

    // Combinational next-state and output logic
    always @(*) begin
        // Defaults
        count_next = count;
        disc_next  = 1'b0;
        flag_next  = 1'b0;
        err_next   = 1'b0;

        if (in) begin
            // Saturating increment
            if (count < 3'd7)
                count_next = count + 3'd1;
            else
                count_next = 3'd7;

            // Error if input 1 and count >= 6 (means 7+ consecutive 1s)
            if (count >= 3'd6)
                err_next = 1'b1;
        end else begin
            // Zero resets count
            count_next = 3'd0;

            // Detect disc and flag conditions based on previous count and current zero input
            case (count)
                3'd5: disc_next = 1'b1; // Stuffed zero after 5 ones -> discard
                3'd6: flag_next = 1'b1; // Flag pattern (0 1111110)
                default: begin end
            endcase
        end
    end

    // Sequential logic: synchronous reset, update count and outputs on posedge clk
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