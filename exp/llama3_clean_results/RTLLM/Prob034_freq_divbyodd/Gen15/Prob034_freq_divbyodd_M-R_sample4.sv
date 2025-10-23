module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [1:0] state;
logic [$clog2(NUM_DIV-1):0] cnt;
logic clk_div_int;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // initial state
                if (cnt == NUM_DIV / 2 - 1) begin
                    state <= 2'b01;
                    clk_div_int <= ~clk_div_int;
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            2'b01: begin // toggled state
                if (cnt == NUM_DIV - 1) begin
                    state <= 2'b00;
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            default: begin
                state <= 2'b00;
                cnt <= 0;
            end
        endcase
    end
end

assign clk_div = clk_div_int;

endmodule