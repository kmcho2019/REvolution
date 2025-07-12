module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;  // 0 = waiting, 1,2 = bytes 1 and 2, done after byte 3

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default no done

            if (count == 2'd0) begin
                if (in[3])        // start byte detected
                    count <= 2'd1;
            end else if (count == 2'd2) begin
                // After second byte, next is third byte
                count <= 2'd3;
            end else if (count == 2'd3) begin
                // Done after third byte received
                done  <= 1'b1;
                count <= 2'd0;  // back to waiting
            end else begin
                // Count == 1, move to next byte
                count <= count + 1'b1;
            end
        end
    end

endmodule