module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active-high reset
    output reg  shift_ena
);

    reg [1:0] cycle_cnt;

    always @(posedge clk) begin
        if (reset) begin
            cycle_cnt <= 2'd0;
            shift_ena <= 1'b1;
        end else if (shift_ena) begin
            if (cycle_cnt == 2'd3) begin
                shift_ena <= 1'b0;
            end else begin
                cycle_cnt <= cycle_cnt + 1'b1;
            end
        end
    end

endmodule