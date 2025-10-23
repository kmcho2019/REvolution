module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

parameter WIDTH = 8;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize with LSB set
        out <= 8'b00000001;
    end else begin
        // Circular shift right with wrap-around
        if (out == 8'b10000000) begin
            out <= 8'b00000001;
        end else begin
            out <= {1'b0, out[WIDTH-1:1]};
        end
    end
end

endmodule