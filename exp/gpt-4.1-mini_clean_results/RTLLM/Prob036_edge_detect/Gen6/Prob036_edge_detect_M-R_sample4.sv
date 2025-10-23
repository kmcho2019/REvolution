module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg [1:0] a_shift;

    // Shift register to hold previous and current samples of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_shift <= 2'b00;
        else
            a_shift <= {a_shift[0], a};
    end

    // rising edge: previous '0', current '1'
    assign rise = (~a_shift[1]) & a_shift[0];
    // falling edge: previous '1', current '0'
    assign down = a_shift[1] & (~a_shift[0]);

endmodule