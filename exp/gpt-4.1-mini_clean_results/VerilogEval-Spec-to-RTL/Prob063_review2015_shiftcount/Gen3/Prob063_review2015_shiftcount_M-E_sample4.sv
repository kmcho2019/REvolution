module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg initialized;

    always @(posedge clk) begin
        if (!initialized) begin
            // On first clock edge, initialize q to a known value, e.g., 4'b0000
            q <= 4'b0000;
            initialized <= 1'b1;
        end else if (shift_ena) begin
            // Shift data into MSB, shift right by 1
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q as a 4-bit down counter with wrap-around
            q <= q - 1'b1;
        end
        // else retain q
    end

    // Initialize 'initialized' flag to 0 at start of simulation (synthesizable as reset state)
    initial begin
        initialized = 1'b0;
    end

endmodule