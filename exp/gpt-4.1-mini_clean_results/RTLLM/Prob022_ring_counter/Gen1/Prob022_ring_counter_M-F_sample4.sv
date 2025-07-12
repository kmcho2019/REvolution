module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk) begin
        if (reset)
            out <= 8'b00000001;
        else begin
            if (out[7])
                out <= 8'b00000001;
            else
                out <= out << 1;
        end
    end

endmodule