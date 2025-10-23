module TopModule (
    input clk,
    input a,
    output reg q
);
    wire a_inv;

    // Combinational inversion of input 'a'
    assign a_inv = ~a;

    // Sequential logic: register captures inverted input on posedge clk
    always @(posedge clk) begin
        q <= a_inv;
    end
endmodule