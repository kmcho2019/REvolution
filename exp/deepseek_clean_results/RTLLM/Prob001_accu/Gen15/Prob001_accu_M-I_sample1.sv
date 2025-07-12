module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // 2-bit saturating counter (0-3)
    reg [9:0] accumulator;  // 10-bit accumulator
    reg [9:0] pipe_reg;     // Pipeline register for timing improvement
    wire count_full;

    // Simplified control signals
    assign count_full = &count;  // AND reduction for final cycle detection

    // Sequential logic for counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
        end
        else if (valid_in) begin
            count <= count + 1'b1;  // Will automatically wrap after 3
        end
    end

    // Sequential logic for accumulator (power-aware)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
            pipe_reg <= 10'b0;
        end
        else if (valid_in) begin
            if (count == 2'b0) begin
                // First input in sequence
                accumulator <= {2'b0, data_in};
                pipe_reg <= 10'b0;
            end
            else begin
                // Pipeline stage 1: partial sum
                pipe_reg <= accumulator + data_in;
                // Pipeline stage 2: final sum or hold
                accumulator <= count_full ? 10'b0 : pipe_reg;
            end
        end
    end

    // Output logic (power optimized)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in && count_full;
            if (valid_in && count_full) begin
                data_out <= pipe_reg + data_in;  // Final sum
            end
        end
    end

endmodule