module TopModule (
    input  clk,
    input  x,
    output z
);

    // Asynchronous active-low reset signal, initialized at simulation start
    reg async_nreset;
    initial async_nreset = 0;
    initial #1 async_nreset = 1; // Release reset shortly after simulation start

    // Flip-flop outputs
    reg xor_q, and_q, or_q;

    // Combinational logic for D inputs of flip-flops
    wire xor_d = x ^ xor_q;
    wire and_d = x & (~and_q);
    wire or_d  = x | (~or_q);

    // D flip-flops with asynchronous active-low reset
    always @(posedge clk or negedge async_nreset) begin
        if (!async_nreset) begin
            xor_q <= 1'b0;
            and_q <= 1'b0;
            or_q  <= 1'b0;
        end else begin
            xor_q <= xor_d;
            and_q <= and_d;
            or_q  <= or_d;
        end
    end

    // Output z is NOR of the flip-flop outputs
    assign z = ~(xor_q | and_q | or_q);

endmodule