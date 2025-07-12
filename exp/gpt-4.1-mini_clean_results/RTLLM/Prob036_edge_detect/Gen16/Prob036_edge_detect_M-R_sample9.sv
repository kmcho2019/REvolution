module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg [1:0] a_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_shift <= 2'b00;
        else
            a_shift <= {a_shift[0], a};
    end

    assign rise = (~a_shift[1]) & a_shift[0];
    assign down = a_shift[1] & (~a_shift[0]);

endmodule