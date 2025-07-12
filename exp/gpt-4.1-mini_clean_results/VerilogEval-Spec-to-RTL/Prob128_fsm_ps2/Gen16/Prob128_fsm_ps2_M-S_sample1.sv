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
            done <= 1'b0; // default de-assert done every cycle

            if (count == 2'd0) begin
                // Waiting for start byte with in[3] == 1
                if (in[3])
                    count <= 2'd1;
            end else begin
                if (count == 2'd2) begin
                    done  <= 1'b1;  // assert done after third byte
                    count <= 2'd0;  // reset to search next message start
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule