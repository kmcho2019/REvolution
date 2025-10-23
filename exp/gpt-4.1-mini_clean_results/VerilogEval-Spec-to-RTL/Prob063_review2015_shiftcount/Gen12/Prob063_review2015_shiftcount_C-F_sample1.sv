module TopModule (
    input        clk,
    input        reset,      // asynchronous reset to ensure defined startup
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire enable = shift_ena | count_ena;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (enable) begin
            if (shift_ena) begin
                // Shift in data MSB-first (shift left)
                q <= {q[2:0], data};
            end else if (count_ena) begin
                // Decrement counter
                q <= q - 1;
            end
        end
        // else hold q (no change)
    end

endmodule