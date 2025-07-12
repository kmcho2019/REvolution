module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // One-hot state encoding
    reg idle, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            idle  <= 1'b1;
            byte2 <= 1'b0;
            byte3 <= 1'b0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // Default no done
            if (idle) begin
                if (in[3]) begin
                    // Found first byte
                    idle  <= 1'b0;
                    byte2 <= 1'b1;
                end
            end else if (byte2) begin
                byte2 <= 1'b0;
                byte3 <= 1'b1;
            end else if (byte3) begin
                byte3 <= 1'b0;
                idle  <= 1'b1;
                done  <= 1'b1;  // Assert done after third byte received
            end
        end
    end

endmodule