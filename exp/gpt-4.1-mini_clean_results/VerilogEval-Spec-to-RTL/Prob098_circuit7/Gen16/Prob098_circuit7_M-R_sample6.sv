module TopModule (
    input clk,
    input a,
    output q
);
    reg a_reg;

    always @(posedge clk) begin
        a_reg <= a; // register input 'a' at clock edge
    end

    assign q = ~a_reg; // combinational inversion of registered input

endmodule