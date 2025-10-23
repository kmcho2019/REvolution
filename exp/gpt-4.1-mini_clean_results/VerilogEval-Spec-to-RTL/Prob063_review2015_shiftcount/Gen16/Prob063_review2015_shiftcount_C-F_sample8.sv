module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Initialization flag for synchronous reset at startup
    reg init_done = 1'b0;

    // Combined enable signal to gate register update and reduce toggling power
    wire ena = shift_ena | count_ena | ~init_done;

    reg [3:0] next_q;

    // Combinational next state logic
    always @* begin
        if (!init_done)
            next_q = 4'b0000;          // Reset to 0 at startup
        else if (shift_ena)
            next_q = {q[2:0], data};   // Shift left, MSB first, new LSB data
        else if (count_ena)
            next_q = q + 4'b1111;      // Decrement: q - 1 mod 16 using addition
        else
            next_q = q;                // Hold current value
    end

    // Sequential logic with gated update
    always @(posedge clk) begin
        if (ena)
            q <= next_q;

        // Mark initialization done after first clock cycle
        if (!init_done)
            init_done <= 1'b1;
    end

endmodule