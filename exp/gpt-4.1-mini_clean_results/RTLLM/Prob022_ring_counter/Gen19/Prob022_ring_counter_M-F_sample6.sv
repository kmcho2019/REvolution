module ring_counter (
    input  clk,
    input  reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;
        end else begin
            // Manually rotate the one-hot bit left by one with wrap-around
            if (out == 8'b0000_0001) out <= 8'b0000_0010;
            else if (out == 8'b0000_0010) out <= 8'b0000_0100;
            else if (out == 8'b0000_0100) out <= 8'b0000_1000;
            else if (out == 8'b0000_1000) out <= 8'b0001_0000;
            else if (out == 8'b0001_0000) out <= 8'b0010_0000;
            else if (out == 8'b0010_0000) out <= 8'b0100_0000;
            else if (out == 8'b0100_0000) out <= 8'b1000_0000;
            else out <= 8'b0000_0001; // covers out == 8'b1000_0000 and any invalid states
        end
    end

endmodule