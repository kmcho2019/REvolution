module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
        end
    end

    assign dout_valid = din_valid & (&dout_parallel[6:0]);  // Valid when all bits except new one are set

endmodule