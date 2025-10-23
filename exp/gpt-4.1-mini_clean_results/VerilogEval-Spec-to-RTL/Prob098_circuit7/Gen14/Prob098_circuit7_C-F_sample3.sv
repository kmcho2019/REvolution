module DFF #(
    parameter INVERT_D = 0  // Parameter to invert input 'd' internally if set
) (
    input clk,
    input d,
    output reg q
);
    wire d_in = INVERT_D ? ~d : d;

    always @(posedge clk) begin
        q <= d_in;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Instantiate DFF with internal inversion of input 'a'
    DFF #(.INVERT_D(1)) dff_inst (
        .clk(clk),
        .d(a),
        .q(q)
    );
endmodule