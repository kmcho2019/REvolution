module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire start_byte_detected;
    wire msg_active;
    wire enable;

    assign start_byte_detected = in[3];
    assign msg_active = (count != 2'd0);
    assign enable = msg_active || start_byte_detected;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0; // default de-assert done each cycle

            if (enable) begin
                if (count == 2'd0) begin
                    // Waiting for start byte with in[3]=1
                    if (start_byte_detected)
                        count <= 2'd1;
                end else begin
                    // Within message bytes 2 and 3
                    if (count == 2'd2) begin
                        done  <= 1'b1;  // assert done after third byte
                        count <= 2'd0;  // reset for next message start search
                    end else begin
                        count <= count + 1'b1;
                    end
                end
            end
            // If enable low, hold count and done remains 0 (already assigned)
        end
    end

endmodule