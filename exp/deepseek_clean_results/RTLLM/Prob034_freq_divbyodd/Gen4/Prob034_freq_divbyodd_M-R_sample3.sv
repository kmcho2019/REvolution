module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam THRESH = (NUM_DIV - 1) / 2;
    reg [$clog2(NUM_DIV):0] counter;
    reg last_clk;
    reg [1:0] state;

    // Edge detector
    wire clk_edge = (clk ^ last_clk);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_clk <= 0;
        end else begin
            last_clk <= clk;
        end
    end

    // Dual-edge counter
    always @(posedge clk_edge or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            state <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end

            // State transitions
            case (state)
                0: state <= (counter == THRESH - 1) ? 1 : 0;
                1: state <= (counter == NUM_DIV - 1) ? 2 : 1;
                2: state <= (counter == THRESH - 1) ? 1 : 2;
                default: state <= 0;
            endcase
        end
    end

    // Output generation
    assign clk_div = (state == 1) || (state == 2 && counter < THRESH);

endmodule