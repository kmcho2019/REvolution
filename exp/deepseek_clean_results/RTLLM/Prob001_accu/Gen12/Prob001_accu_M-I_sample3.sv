module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // 2-bit counter (0-3)
    reg [9:0] accumulator;  // 10-bit accumulator
    reg [9:0] pipe_reg;     // Pipeline register
    wire count_full;

    // Optimized combinational logic
    assign count_full = &count;  // Detect count==3 using AND reduction

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            pipe_reg <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Counter logic
            if (valid_in) begin
                count <= count + 1'b1;
            end

            // Two-stage accumulation pipeline
            if (valid_in) begin
                pipe_reg <= accumulator + data_in;
            end

            // Final accumulation stage
            if (valid_in && count_full) begin
                accumulator <= 10'b0;
            end
            else if (valid_in) begin
                accumulator <= pipe_reg;
            end

            // Output logic
            valid_out <= valid_in && count_full;
            if (valid_in && count_full) begin
                data_out <= pipe_reg;
            end
        end
    end

endmodule