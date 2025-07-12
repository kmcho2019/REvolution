module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Generate reversed vector by concatenating bits from MSB to LSB
    assign out = { 
        in[0]
    };
    // The above is a placeholder; implement full reversal in a generate block
    
    // Use a generate block to create a reversed concatenation
    wire [N-1:0] reversed;
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_concat
            assign reversed[i] = in[N - 1 - i];
        end
    endgenerate
    assign out = reversed;
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule