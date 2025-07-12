module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg [1:0] a_sync;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    assign rise = (a_sync == 2'b01);
    assign down = (a_sync == 2'b10);

endmodule