module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire      start_byte_detected;
    wire      msg_active;
    wire      enable;

    assign start_byte_detected = in[3];
    assign msg_active = (count != 2'd0);
    assign enable = msg_active || start_byte_detected;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            if (enable) begin
                if (count == 2'd0) begin
                    // Waiting for start byte
                    if (start_byte_detected)
                        count <= 2'd1;
                    // else count remains 0
                end else begin
                    // Inside message: bytes 2 and 3
                    if (count == 2'd2) begin
                        done  <= 1'b1;  // done after third byte
                        count <= 2'd0;  // reset to wait for next start byte
                    end else begin
                        count <= count + 1'b1;
                    end
                end
            end
            // When enable is low, hold count and done=0 (already done=0)
            // This gating avoids unnecessary count increments or done toggling
        end
    end

endmodule