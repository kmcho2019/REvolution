module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;          // 2-bit counter (0-3)
    reg [9:0] accumulator;    // 10-bit accumulator
    reg [9:0] sum_pipeline;    // Pipeline register for final sum
    reg accu_en;              // Clock enable for accumulator

    // Clock gating control
    always @(*) begin
        accu_en = valid_in && (count != 2'b11);
    end

    // Counter and accumulator logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            sum_pipeline <= 10'b0;
        end
        else begin
            // Counter logic
            if (valid_in) begin
                count <= (count == 2'b11) ? 2'b00 : count + 1'b1;
            end

            // Accumulator logic with clock gating
            if (accu_en) begin
                accumulator <= accumulator + data_in;
            end
            else if (valid_in && (count == 2'b11)) begin
                // Capture final sum in pipeline register
                sum_pipeline <= accumulator + data_in;
                accumulator <= 10'b0;  // Reset accumulator
            end
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            valid_out <= valid_in && (count == 2'b11);
            if (valid_in && (count == 2'b11)) begin
                data_out <= sum_pipeline;
            end
        end
    end

endmodule