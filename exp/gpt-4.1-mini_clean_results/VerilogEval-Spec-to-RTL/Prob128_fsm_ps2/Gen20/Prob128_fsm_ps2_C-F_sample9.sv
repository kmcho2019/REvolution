module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire start_byte = in[3];
    wire msg_active = (count != 2'd0);
    wire enable = msg_active || start_byte;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0; // default done low every cycle

            if (enable) begin
                if (count == 2'd0) begin
                    // Waiting for start byte
                    if (start_byte)
                        count <= 2'd1;
                end else if (count == 2'd2) begin
                    // After third byte received
                    done  <= 1'b1;  // pulse done
                    count <= 2'd0;  // reset for next message
                end else begin
                    count <= count + 1'b1;
                end
            end
            // When enable is low, count holds, avoiding toggling
        end
    end

endmodule