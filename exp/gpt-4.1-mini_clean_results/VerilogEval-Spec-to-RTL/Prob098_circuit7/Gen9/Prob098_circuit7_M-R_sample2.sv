module TopModule (
    input clk,
    input a,
    output reg q
);
    wire a_inv;
    assign a_inv = ~a;  // combinational inversion of a

    always @(posedge clk) begin
        q <= a_inv;     // capture the inverted a at clock edge
    end
endmodule