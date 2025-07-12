module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] position;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'b000;
            out <= 8'b00000001; // Initialize LSB high
        end else begin
            position <= position + 3'b001; // increment modulo 8 due to 3-bit width wrap-around
            out <= 8'b00000001 << position; // assign one-hot output in sequential block (supported)
        end
    end

endmodule