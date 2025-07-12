module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

// Check if NUM_DIV is odd, if not default to 5
localparam integer DIV = (NUM_DIV % 2 == 1) ? NUM_DIV : 5;

// Define the states of the FSM
enum logic [1:0] {HIGH, LOW} state, next_state;

// Counter for clock edges
reg [31:0] cnt;

// Internal clock divider output
reg clk_div_int;

// Always block for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= HIGH;
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        case (state)
            HIGH: begin
                if (cnt == (DIV - 1) / 2) begin
                    state <= LOW;
                    clk_div_int <= ~clk_div_int;
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            LOW: begin
                if (cnt == (DIV - 1) / 2) begin
                    state <= HIGH;
                    clk_div_int <= ~clk_div_int;
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            default: state <= HIGH;
        endcase
    end
end

assign clk_div = clk_div_int;

endmodule