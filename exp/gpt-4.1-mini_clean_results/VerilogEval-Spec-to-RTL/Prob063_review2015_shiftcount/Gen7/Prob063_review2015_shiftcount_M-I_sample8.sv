module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Optional reset initialization for safer simulation; remove if not needed
    initial q = 4'b0000;

    always @(posedge clk) begin
        if (shift_ena || count_ena) begin
            // Compute next value based on enables
            // If shift_ena is high, shift left and insert data at LSB
            // else decrement q
            // Both not high simultaneously per spec, so priority here doesn't matter
            q <= shift_ena ? {q[2:0], data} : (q - 1);
        end
        // else hold q
    end

endmodule