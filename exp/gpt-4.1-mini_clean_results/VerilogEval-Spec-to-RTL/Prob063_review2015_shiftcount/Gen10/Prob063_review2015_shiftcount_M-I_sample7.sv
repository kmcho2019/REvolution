module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Synchronous reset to 0 at startup (optional)
    // Remove or adapt if reset input is added externally
    reg init_done = 0;
    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1;
        end
        else begin
            if (shift_ena) begin
                // Shift left (MSB first) with new data in LSB
                q <= {q[2:0], data};
            end
            else if (count_ena) begin
                // Decrement using adder with carry-in tied to 1 (q - 1)
                q <= q + 4'b1111;  // same as q - 1 mod 16
            end
            else begin
                // Hold value
                q <= q;
            end
        end
    end

endmodule