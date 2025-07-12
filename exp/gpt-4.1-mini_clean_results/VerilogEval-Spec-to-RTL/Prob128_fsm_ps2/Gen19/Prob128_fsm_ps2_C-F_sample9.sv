module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire      start_byte = in[3];
    wire      enable;

    // Enable counting when waiting for start byte and start_byte detected, or while inside a message
    assign enable = (count == 2'd0) ? start_byte : 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            if (enable) begin
                if (count == 2'd0) begin
                    // Waiting for start byte
                    if (start_byte)
                        count <= 2'd1;
                end else if (count == 2'd2) begin
                    // Received third byte, done pulse and reset count
                    done  <= 1'b1;
                    count <= 2'd0;
                end else begin
                    // Counting bytes 2 and 3
                    count <= count + 1'b1;
                end
            end
            // else: hold count and done low to reduce toggling
        end
    end

endmodule