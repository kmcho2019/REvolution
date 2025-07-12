module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count; // 0 = searching, 1..3 = message bytes received

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (byte_count == 2'd0) begin
                // Looking for start byte with in[3] == 1
                if (in[3]) 
                    byte_count <= 2'd1; // First byte found
            end else if (byte_count < 2'd3) begin
                byte_count <= byte_count + 2'd1;
            end else begin
                // byte_count == 3, message complete
                done <= 1'b1;
                byte_count <= 2'd0; // reset to search for next message
            end
        end
    end

endmodule