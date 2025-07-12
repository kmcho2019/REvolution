module TopModule (
    input  clk,
    input  x,
    output z
);

    // Asynchronous reset signal, active high
    reg reset_n;

    initial begin
        reset_n = 1'b0;      // Assert reset at start
        #1 reset_n = 1'b1;   // Deassert reset shortly after time 0
    end

    // Flip-flop state registers
    reg xor_ff, and_ff, or_ff;

    // Combinational logic inputs to flip-flops
    wire xor_in = x ^ xor_ff;
    wire and_in = x & (~and_ff);
    wire or_in  = x | (~or_ff);

    // D flip-flops with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= xor_in;
            and_ff <= and_in;
            or_ff  <= or_in;
        end
    end

    // Output z is NOR of flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule