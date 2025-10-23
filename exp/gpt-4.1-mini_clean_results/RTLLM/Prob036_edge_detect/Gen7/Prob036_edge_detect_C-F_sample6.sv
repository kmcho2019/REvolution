module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_shift <= 2'b00;
            rise    <= 1'b0;
            down    <= 1'b0;
        end else begin
            a_shift <= {a_shift[0], a};
            // detect edges from previous and current 'a' values
            rise <= (~a_shift[1]) & a_shift[0];
            down <= a_shift[1] & (~a_shift[0]);
        end
    end

endmodule