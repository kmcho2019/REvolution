module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] ones_count;  // counts consecutive ones from 0 to 6 (max)
    reg       disc_next, flag_next, err_next;

    always @(*) begin
        // Defaults
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        if (in) begin
            if (ones_count == 3'd6) begin
                // Seven or more consecutive ones: error
                err_next = 1'b1;
            end
            // else no output now
        end else begin
            // Input zero after count of ones:
            case (ones_count)
                3'd5: disc_next = 1'b1;  // inserted zero after 5 ones
                3'd6: flag_next = 1'b1;  // flag detected (6 ones then zero)
                default: ; // no output
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            ones_count <= 3'd0;
            disc       <= 1'b0;
            flag       <= 1'b0;
            err        <= 1'b0;
        end else begin
            // Update count
            if (in) begin
                if (ones_count < 3'd6)
                    ones_count <= ones_count + 3'd1;
                else
                    ones_count <= ones_count; // stay at 6 in error condition
            end else begin
                ones_count <= 3'd0;
            end

            // Register outputs (Moore)
            disc <= disc_next;
            flag <= flag_next;
            err  <= err_next;
        end
    end

endmodule