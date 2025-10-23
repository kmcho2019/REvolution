module TopModule(
    input  clk,
    input  rst_n,       // Active-low asynchronous reset
    input  shift_ena,
    input  count_ena,
    input  data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational next state logic with priority: shift_ena > count_ena
    always @(*) begin
        if (shift_ena)
            next_q = {q[2:0], data};  // Shift left, MSB-first shift register input at LSB
        else if (count_ena)
            next_q = q - 1;           // Decrement by 1
        else
            next_q = q;               // Hold current state
    end

    // Clock enable when either shift or count is enabled
    wire update_en = shift_ena | count_ena;

    // Sequential logic with asynchronous active-low reset and clock enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;
        else if (update_en)
            q <= next_q;
        // else hold implicitly
    end

endmodule