module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal synchronous reset generated at power-on via shift register
    reg [1:0] reset_sync = 2'b11; // Start asserted for at least two cycles
    wire reset = reset_sync[1];

    always @(posedge clk) begin
        reset_sync <= {reset_sync[0], 1'b0};
    end

    // Flip-flops storing the outputs of the XOR, AND, and OR gates
    reg xor_ff, and_ff, or_ff;

    // Combinational logic for next state inputs
    wire xor_d = x ^ xor_ff;
    wire and_d = x & (~and_ff);
    wire or_d  = x | (~or_ff);

    // Flip-flops update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= xor_d;
            and_ff <= and_d;
            or_ff  <= or_d;
        end
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule