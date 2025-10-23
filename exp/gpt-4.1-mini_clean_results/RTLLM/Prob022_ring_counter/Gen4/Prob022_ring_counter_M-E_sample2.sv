module ring_counter (
    input  wire        clk,
    input  wire        reset,
    output reg  [7:0]  out
);

    reg [2:0] position;

    // Update the position on clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            position <= 3'b000; // initialize to 0
        else
            position <= position + 3'd1; // increment modulo 8 (3-bit wraps naturally)
    end

    // Combinational decoding of position to one-hot output
    always @(*) begin
        out = 8'b00000000;
        out[position] = 1'b1;
    end

endmodule