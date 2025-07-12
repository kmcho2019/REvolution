module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

parameter INIT_STATE = 8'b00000001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= INIT_STATE;
    end else begin
        if (out == 8'b10000000) begin
            out <= INIT_STATE;  // Wrap around
        end else begin
            out <= out << 1;    // Shift left
        end
    end
end

endmodule