module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter
reg        clk_div_int;  // Internal divided clock signal
reg [1:0]  state;  // State machine state

localparam IDLE = 2'b00;
localparam DIVIDED = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (cnt < (NUM_DIV - 1) / 2) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 0;
                    clk_div_int <= ~clk_div_int;
                    state <= DIVIDED;
                end
            end
            DIVIDED: begin
                if (cnt < NUM_DIV - 1) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign clk_div = clk_div_int;

endmodule