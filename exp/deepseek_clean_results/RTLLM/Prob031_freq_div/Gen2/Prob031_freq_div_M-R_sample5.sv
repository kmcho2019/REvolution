module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Clock enables
    wire clk_50_en = 1'b1;  // Always enabled
    wire clk_10_en;
    wire clk_1_en;

    // Counter modules
    div_counter #(.MAX(1))  u_div2  (.clk(CLK_in), .rst(RST), .en(clk_50_en), .clk_out(CLK_50));
    div_counter #(.MAX(4))  u_div10 (.clk(CLK_in), .rst(RST), .en(clk_10_en), .clk_out(CLK_10));
    div_counter #(.MAX(49)) u_div100(.clk(CLK_in), .rst(RST), .en(clk_1_en), .clk_out(CLK_1));

    // Enable generation
    assign clk_10_en = (u_div10.count == 4);
    assign clk_1_en  = (u_div100.count == 49);

endmodule

module div_counter #(
    parameter MAX = 1
)(
    input clk,
    input rst,
    input en,
    output reg clk_out
);
    reg [$clog2(MAX):0] count;
    wire [MAX:0] max_val = MAX;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else if (en) begin
            if (count == max_val) begin
                count <= 0;
                clk_out <= ~clk_out;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule