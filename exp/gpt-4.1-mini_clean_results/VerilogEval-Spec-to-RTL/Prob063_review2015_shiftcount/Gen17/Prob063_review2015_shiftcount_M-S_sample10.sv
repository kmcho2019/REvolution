module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena)
            q <= {q[2:0], data};    // Shift left, MSB-first data input
        else if (count_ena)
            q <= q - 1;            // Decrement modulo 16
        // else hold q
    end

    // Optional: initial block to set q to zero for simulation
    initial begin
        q = 4'b0000;
    end

endmodule