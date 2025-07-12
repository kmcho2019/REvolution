module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output [3:0] q
);

    reg [3:0] q_reg;
    reg       init_done;

    // Shift operation: shift left and input 'data' at LSB (MSB-first shift)
    wire [3:0] shift_val = {q_reg[2:0], data};

    // Count operation: decrement by 1 using addition with 4'b1111 (equivalent to q - 1 mod 16)
    wire [3:0] count_val = q_reg + 4'b1111;

    // Select next value, prioritizing shift_ena over count_ena
    wire [3:0] next_val = shift_ena ? shift_val :
                         count_ena ? count_val :
                         q_reg;

    // Enable register update during initialization or when either shift or count is enabled
    wire ena = (shift_ena | count_ena) | (~init_done);

    always @(posedge clk) begin
        if (~init_done) begin
            q_reg <= 4'b0000;
            init_done <= 1'b1;
        end else if (ena) begin
            q_reg <= next_val;
        end
    end

    assign q = q_reg;

endmodule