module TopModule (
    input  clk,
    input  x,
    input  rst_n,  // Active low asynchronous reset input
    output z
);

    // Separate flip-flops for each gate output
    reg xor_ff;
    reg and_ff;
    reg or_ff;

    // Combinational logic for D inputs
    wire xor_d = x ^ xor_ff;
    wire and_d = x & (~and_ff);
    wire or_d  = x | (~or_ff);

    // Sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= xor_d;
            and_ff <= and_d;
            or_ff  <= or_d;
        end
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule