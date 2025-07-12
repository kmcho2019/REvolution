module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default clear done each cycle

            if (count == 2'd0) begin
                // Waiting for first byte (start of message)
                if (in[3]) begin
                    count <= 2'd1;
                end
            end else begin
                // Inside message: count bytes 2 and 3
                if (count == 2'd2) begin
                    // Third byte received: assert done and reset count
                    done  <= 1'b1;
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule