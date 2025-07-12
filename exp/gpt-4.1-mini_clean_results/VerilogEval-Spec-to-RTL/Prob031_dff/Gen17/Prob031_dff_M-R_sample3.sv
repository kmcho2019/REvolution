module DFF #(parameter WIDTH = 1) (
    input clk,
    input [WIDTH-1:0] d,
    output wire [WIDTH-1:0] q
);
    reg [WIDTH-1:0] q_reg;
    
    assign q = q_reg;

    always @(posedge clk) begin
        q_reg <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    // Instantiate parameterized DFF with WIDTH=1
    DFF #(.WIDTH(1)) dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule