module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;  // tracks byte position: 0 = waiting for start, 1..3 counting bytes

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low each cycle

            if (count == 2'd0) begin
                // Waiting for start byte: check in[3]
                if (in[3] == 1'b1) begin
                    count <= 2'd1;
                end
            end else if (count == 2'd3) begin
                // Third byte received, signal done and reset count
                done  <= 1'b1;
                count <= 2'd0;
            end else begin
                // Counting bytes 2 and 3
                count <= count + 1'b1;
            end
        end
    end

endmodule