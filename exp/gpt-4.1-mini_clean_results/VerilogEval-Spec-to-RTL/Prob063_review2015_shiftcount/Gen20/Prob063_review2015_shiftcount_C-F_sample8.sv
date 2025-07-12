module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Mutually exclusive enables: shift has priority if both asserted
    wire shift_en = shift_ena;
    wire count_en = count_ena & ~shift_ena;

    reg init_done;
    reg [3:0] next_q;

    // Initialization register and logic: synchronous reset-like initialization on first clock
    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1'b1;
        end else begin
            q <= next_q;
        end
    end

    // Combinational logic for next state based on mutually exclusive enables
    always @(*) begin
        if (shift_en)
            next_q = {q[2:0], data};        // shift left, MSB first (shift in LSB)
        else if (count_en)
            next_q = q + 4'b1111;           // decrement by 1 mod 16 (q - 1)
        else
            next_q = q;                     // hold
    end

endmodule