module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] position;

    // Update position on clock edge or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'b000; // Initialize position to 0
        end else begin
            position <= position + 3'b001; // Increment position modulo 8 automatically by 3-bit wrap-around
        end
    end

    // Generate one-hot output based on current position
    always @(*) begin
        out = 8'b00000001 << position;
    end

endmodule