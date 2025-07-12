module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 8'b00000001;
        else begin
            if (out[7])
                out <= 8'b00000001;   // wrap around
            else
                out <= out << 1;
        end
    end

endmodule