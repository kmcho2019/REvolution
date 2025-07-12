module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count; // counts 0 to 3: 0 means waiting for start byte

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            if (byte_count == 2'd0) begin
                // Not currently in message; look for start byte
                if (in[3]) 
                    byte_count <= 2'd1; // first byte found
            end else if (byte_count == 2'd1) begin
                // Received 1st byte, waiting for 2nd byte
                byte_count <= 2'd2;
            end else if (byte_count == 2'd2) begin
                // Received 2nd byte, waiting for 3rd byte
                byte_count <= 2'd3;
            end else if (byte_count == 2'd3) begin
                // Received 3rd byte, message complete
                done       <= 1'b1;
                byte_count <= 2'd0; // reset to search for next start byte
            end
        end
    end

endmodule