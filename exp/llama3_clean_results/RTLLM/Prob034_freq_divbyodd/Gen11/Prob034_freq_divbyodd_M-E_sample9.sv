module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter to track clock cycles
reg        clk_div_int;  // Internal divided clock
reg        state;  // Current state of the FSM

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
        state <= 1'b0;
    end else begin
        if (state == 1'b0) begin
            if (cnt == (NUM_DIV / 2)) begin
                clk_div_int <= ~clk_div_int;
                cnt <= 0;
                state <= 1'b1;
            end else begin
                cnt <= cnt + 1;
            end
        end else begin
            if (cnt == (NUM_DIV - (NUM_DIV / 2) - 1)) begin
                state <= 1'b0;
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
end

assign clk_div = clk_div_int;

endmodule