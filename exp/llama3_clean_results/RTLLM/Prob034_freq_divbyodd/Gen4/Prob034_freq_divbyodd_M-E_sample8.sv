module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt; // Counter for input clock cycles
reg [31:0] div_cnt; // Counter for divided clock output
reg        clk_div_int; // Internal divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        div_cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        cnt <= cnt + 1;
        if (cnt == (NUM_DIV / 2)) begin
            div_cnt <= div_cnt + 1;
            cnt <= 0;
            if (div_cnt == 1) begin
                clk_div_int <= ~clk_div_int;
                div_cnt <= 0;
            end
        end
    end
end

assign clk_div = clk_div_int;

endmodule