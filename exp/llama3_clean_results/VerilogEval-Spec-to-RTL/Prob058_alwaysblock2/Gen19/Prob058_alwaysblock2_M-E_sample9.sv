module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    // Define the XOR gate
    assign out_assign = a ^ b;

    // Define the combinational always block
    reg out_comb;
    always_comb begin
        out_comb = a ^ b;
    end
    assign out_always_comb = out_comb;

    // Define the clocked always block with a flip-flop
    reg out_ff;
    always_ff @(posedge clk) begin
        out_ff <= a ^ b;
    end
    assign out_always_ff = out_ff;

    // Alternatively, using a multiplexor-based approach
    // reg mux_out;
    // always_comb begin
    //     if (clk) begin
    //         mux_out = out_ff;
    //     end else begin
    //         mux_out = out_comb;
    //     end
    // end
    // assign out_always_ff = mux_out;
endmodule