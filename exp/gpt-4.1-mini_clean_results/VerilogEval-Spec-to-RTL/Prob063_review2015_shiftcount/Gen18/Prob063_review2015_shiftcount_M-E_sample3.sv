module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] q_next;

    // Synchronous reset on first clock cycle (assumes power-on q=0)
    // For clarity, use a reset flag to initialize on first clock edge
    reg init_done;

    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1'b1;
        end else if (shift_ena) begin
            // Shift in data at MSB side; bits move towards LSB
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q mod 16 (4 bits wrap around)
            q <= q - 1'b1;
        end else begin
            // Hold current value when no enable asserted
            q <= q;
        end
    end

endmodule