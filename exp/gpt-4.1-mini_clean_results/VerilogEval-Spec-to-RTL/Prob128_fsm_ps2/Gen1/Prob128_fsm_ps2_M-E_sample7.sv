module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done unless third byte reached

            if (byte_count == 2'd3) begin
                // After done asserted, reset counter to zero for next message
                byte_count <= 2'd0;
                done <= 1'b1;
            end else begin
                if (byte_count == 2'd0) begin
                    // Looking for first byte: start count if in[3] == 1
                    if (in[3]) begin
                        byte_count <= 2'd1;
                    end
                end else begin
                    // Counting 2nd or 3rd byte
                    byte_count <= byte_count + 1;
                end
            end
        end
    end

endmodule