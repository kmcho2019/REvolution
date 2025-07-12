module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output [3:0]   q
);

    reg [3:0] q_reg;

    // Shift operation: shift left and input 'data' at LSB
    wire [3:0] shift_val = {q_reg[2:0], data};

    // Count operation: decrement by 1
    wire [3:0] count_val = q_reg - 4'd1;

    // Select next value, prioritizing shift_ena over count_ena
    wire [3:0] next_q = shift_ena ? shift_val :
                        count_ena ? count_val :
                        q_reg;

    // Combined enable to update register
    wire ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (ena)
            q_reg <= next_q;
    end

    assign q = q_reg;

endmodule