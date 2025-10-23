module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] index;

    always @(posedge clk) begin
        if (reset) begin
            index <= 3'b000;
        end else begin
            index <= index + 1'b1;  // Increment index modulo 8
        end
    end

    always @(*) begin
        // One-hot decode: only the bit at 'index' is set
        out = 8'b00000000;
        out[index] = 1'b1;
    end

endmodule