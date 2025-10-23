module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire start_byte = in[3];
    wire enable     = (count != 2'd0) | start_byte;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low each cycle

            if (enable) begin
                if (count == 2'd0) begin
                    // Waiting for start byte
                    if (start_byte)
                        count <= 2'd1;
                end else begin
                    // Inside message: second or third byte
                    if (count == 2'd2) begin
                        done  <= 1'b1;  // done pulse after third byte
                        count <= 2'd0;  // reset to wait for next message
                    end else begin
                        count <= count + 1'b1;
                    end
                end
            end
            // If enable low, hold count and done=0, reducing toggling
        end
    end

endmodule