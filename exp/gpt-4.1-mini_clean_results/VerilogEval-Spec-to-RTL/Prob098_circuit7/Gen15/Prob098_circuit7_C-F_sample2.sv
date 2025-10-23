module DFF (
    input clk,
    input reset_n,
    input d,
    output reg q
);
    // Asynchronous active-low reset to initialize q
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    wire not_a = ~a;
    // Tie reset_n permanently high (no reset) since waveform doesn't specify reset
    wire reset_n = 1'b1;

    DFF dff_inst (
        .clk(clk),
        .reset_n(reset_n),
        .d(not_a),
        .q(q)
    );
endmodule