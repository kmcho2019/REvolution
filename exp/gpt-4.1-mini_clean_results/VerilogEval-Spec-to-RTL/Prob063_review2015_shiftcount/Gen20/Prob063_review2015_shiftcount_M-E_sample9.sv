module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Initialization flag to reset q at the first clock
    reg init_done;

    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;      // Reset register at startup
            init_done <= 1'b1; // Initialization complete
        end else if (shift_ena) begin
            // Shift left by 1 with new MSB = data input
            // Shifting MSB first: data goes into q[3], q[3]->q[2], ...
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q by 1 modulo 16 using subtraction
            q <= q - 4'b0001;
        end
        // else hold the current value (no else clause needed since q is reg)
    end

endmodule