module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Initialization done flag for synchronous reset at startup
    reg init_done = 1'b0;

    // Combined enable: update register only if shifting, counting or init not done
    wire ena = shift_ena | count_ena | ~init_done;

    reg [3:0] next_q;

    // Next state logic: synchronous reset, shift, decrement, or hold
    always @* begin
        if (!init_done) begin
            next_q = 4'b0000;               // Reset at startup
        end else if (shift_ena) begin
            next_q = {q[2:0], data};        // Shift left (MSB-first input into LSB)
        end else if (count_ena) begin
            next_q = q + 4'b1111;           // Decrement by 1 modulo 16
        end else begin
            next_q = q;                    // Hold current value
        end
    end

    // Sequential logic: register update gated by ena, synchronous init_done flag set
    always @(posedge clk) begin
        if (ena)
            q <= next_q;

        if (!init_done)
            init_done <= 1'b1;
    end

endmodule