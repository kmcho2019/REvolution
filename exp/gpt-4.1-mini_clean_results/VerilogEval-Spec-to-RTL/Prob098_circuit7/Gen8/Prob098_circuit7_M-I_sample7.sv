module DFF_inverted (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= ~d; // invert d inside the flip-flop logic
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Directly feed 'a' to the DFF_inverted which internally inverts it on clock edge
    DFF_inverted dff_inst (
        .clk(clk),
        .d(a),
        .q(q)
    );
endmodule