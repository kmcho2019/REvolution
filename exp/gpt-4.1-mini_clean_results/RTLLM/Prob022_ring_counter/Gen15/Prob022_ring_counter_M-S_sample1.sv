module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            if (out[7] == 1'b1)
                out <= 8'b00000001;
            else
                out <= out << 1;
        end
    end

endmodule