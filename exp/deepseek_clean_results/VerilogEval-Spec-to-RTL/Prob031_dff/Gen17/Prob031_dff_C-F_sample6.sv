`default_nettype none

module DFF(
    input wire clk,
    input wire d,
    output wire q
);
    reg q_reg;
    
    always @(posedge clk) begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule

module TopModule(
    input wire clk,
    input wire d,
    output wire q
);
    DFF dff_inst(
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule

`default_nettype wire