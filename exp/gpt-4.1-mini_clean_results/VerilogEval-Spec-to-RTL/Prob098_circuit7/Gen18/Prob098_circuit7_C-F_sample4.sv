module DFF (
    input clk,
    input d,
    output reg q
);
    // Sequential logic: capture input 'd' on rising edge of clk
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    wire inverted_a;

    // Combinational inversion of input 'a'
    assign inverted_a = ~a;

    // Instantiate D flip-flop with inverted input
    DFF dff_inst (
        .clk(clk),
        .d(inverted_a),
        .q(q)
    );
endmodule