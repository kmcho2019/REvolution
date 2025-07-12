module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire      start_byte;
    wire      msg_active;
    wire      enable;

    assign start_byte = in[3];
    assign msg_active  = (count != 2'd0);
    assign enable      = (count == 2'd0) ? start_byte : 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low each cycle

            if (enable) begin
                if (count == 2'd0) begin
                    // Waiting for start byte (in[3]==1)
                    if (start_byte)
                        count <= 2'd1;
                end else begin
                    // Inside message: bytes 2 and 3
                    if (count == 2'd2) begin
                        done  <= 1'b1;  // done pulse after third byte
                        count <= 2'd0;  // reset to wait for next start byte
                    end else begin
                        count <= count + 1'b1;
                    end
                end
            end
            // When enable is low, hold count and done=0 (already done=0)
            // Enables toggling only when needed, reducing unnecessary switching
        end
    end

endmodule