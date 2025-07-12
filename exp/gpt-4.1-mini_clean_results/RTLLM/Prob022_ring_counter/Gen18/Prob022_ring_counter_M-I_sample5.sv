module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            out <= (out[7]) ? 8'b00000001 : (out << 1);
        end
    end

endmodule