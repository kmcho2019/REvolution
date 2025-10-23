module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] byte_count;

    // Byte count meanings:
    // 0 - idle, waiting for start byte
    // 1 - received byte 1 (start byte)
    // 2 - received byte 2
    // 3 - received byte 3

    // State update: on reset, go idle (0)
    // On idle, if in[3]==1 start counting from 1
    // Otherwise, if counting <3, increment count by 1 each byte
    // If count == 3, after that cycle goes back to idle
    
    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
        end else begin
            if (byte_count == 2'd0) begin
                // waiting for start byte
                if (in[3])
                    byte_count <= 2'd1; // start counting
                else
                    byte_count <= 2'd0;
            end else if (byte_count < 2'd3) begin
                // count up bytes in message
                byte_count <= byte_count + 2'd1;
            end else begin
                // after third byte, go back to idle to look for next start byte
                byte_count <= 2'd0;
            end
        end
    end

    // done asserted combinationally: true if byte_count == 3 in this cycle
    assign done = (byte_count == 2'd3);

endmodule