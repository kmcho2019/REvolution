// 8-bit register module with active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] reg_data;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            reg_data <= 8'b0;
        end else begin
            reg_data <= d;
        end
    end

    assign q = reg_data;

endmodule