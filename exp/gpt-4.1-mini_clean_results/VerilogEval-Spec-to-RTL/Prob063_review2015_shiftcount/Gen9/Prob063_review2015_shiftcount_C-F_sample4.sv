module TopModule(
    input  clk,
    input  rst_n,       // Active-low asynchronous reset
    input  shift_ena,
    input  count_ena,
    input  data,
    output reg [3:0] q
);

    // Compute next values combinationally
    wire [3:0] shift_val = {q[2:0], data}; // MSB-first shift: shift left, insert data at LSB
    wire [3:0] count_val = q - 1;

    // Next state logic: priority shift_ena > count_ena, else hold
    wire [3:0] next_q = shift_ena ? shift_val :
                       count_ena ? count_val :
                       q;

    // Enable update only when either shift_ena or count_ena is asserted to reduce toggling
    wire update_en = shift_ena | count_ena;

    // Asynchronous reset and clocked update with clock enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;
        else if (update_en)
            q <= next_q;
        else
            q <= q; // hold
    end

endmodule