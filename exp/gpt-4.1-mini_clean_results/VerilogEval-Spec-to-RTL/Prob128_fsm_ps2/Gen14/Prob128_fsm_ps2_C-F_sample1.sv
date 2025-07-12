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
            done <= 1'b0; // default done de-assertion

            if (count == 2'd0) begin
                // Waiting for start byte with in[3] = 1
                if (in[3])
                    count <= 2'd1;
            end else begin
                if (count == 2'd2) begin
                    // Third byte received: assert done and reset count
                    done  <= 1'b1;
                    count <= 2'd0;
                end else begin
                    // Second byte or first byte after start byte
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule