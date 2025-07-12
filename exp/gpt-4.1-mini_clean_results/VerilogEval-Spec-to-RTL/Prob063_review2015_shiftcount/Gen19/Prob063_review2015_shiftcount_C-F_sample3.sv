module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Synchronous reset signal derived by reset-initializing register to zero at startup
    // Use a power-on reset style with a register initialized to zero on first clock edge.
    reg init_done = 0;

    // Next value wires
    wire [3:0] shift_val = {q[2:0], data};
    wire [3:0] count_val = q + 4'b1111; // q - 1 modulo 16 using add with 4'b1111

    // Priority: shift_ena first, then count_ena
    wire [3:0] next_q = shift_ena ? shift_val :
                        count_ena ? count_val :
                        q;

    wire ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1'b1;
        end else if (ena) begin
            q <= next_q;
        end
    end

endmodule