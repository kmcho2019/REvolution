module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done       <= 1'b0;
        end else begin
            if (byte_count == 2'd0) begin
                // Waiting for start byte with in[3] == 1
                if (in[3])
                    byte_count <= 2'd1;
                else
                    byte_count <= 2'd0;
                done <= 1'b0;
            end else if (byte_count == 2'd1) begin
                // Byte 2 received
                byte_count <= 2'd2;
                done <= 1'b0;
            end else if (byte_count == 2'd2) begin
                // Byte 3 received: signal done and reset count
                byte_count <= 2'd0;
                done <= 1'b1;
            end else begin
                // Default safe state
                byte_count <= 2'd0;
                done <= 1'b0;
            end
        end
    end

endmodule