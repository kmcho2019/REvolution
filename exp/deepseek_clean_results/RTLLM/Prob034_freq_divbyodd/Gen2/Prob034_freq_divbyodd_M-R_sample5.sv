module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [$clog2(NUM_DIV):0] counter;
    reg state;
    wire counter_max = (counter == NUM_DIV - 1);
    wire counter_half = (counter == (NUM_DIV - 1)/2);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            state <= 0;
        end else begin
            if (counter_max) begin
                counter <= 0;
                state <= ~state;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Negative edge block only for midpoint toggle
        end else begin
            if (counter_half && !counter_max) begin
                state <= ~state;
            end
        end
    end

    assign clk_div = state;

endmodule