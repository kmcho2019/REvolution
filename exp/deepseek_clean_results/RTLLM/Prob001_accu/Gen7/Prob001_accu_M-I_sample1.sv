module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;            // Counter for 0-3 (4 inputs)
    reg [8:0] accum_stage1;     // First stage accumulator (9 bits)
    reg [9:0] accum_stage2;     // Second stage accumulator (10 bits)
    wire accum_enable = valid_in;
    wire output_ready;

    // Pipeline the count comparison
    reg count_eq_3;
    always @(posedge clk) begin
        if (!rst_n) begin
            count_eq_3 <= 1'b0;
        end else begin
            count_eq_3 <= (count == 2'b11);
        end
    end

    assign output_ready = count_eq_3 & valid_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accum_stage1 <= 9'b0;
            accum_stage2 <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            // Only update valid_out when needed
            if (output_ready) begin
                valid_out <= 1'b1;
                data_out <= accum_stage2 + data_in;
            end else begin
                valid_out <= 1'b0;
            end

            if (accum_enable) begin
                if (output_ready) begin
                    // Reset on output
                    count <= 2'b00;
                    accum_stage1 <= 9'b0;
                    accum_stage2 <= 10'b0;
                end else begin
                    // Pipeline the accumulation
                    if (count[0] == 1'b0) begin
                        // First stage: add two inputs
                        accum_stage1 <= accum_stage1 + data_in;
                    end else begin
                        // Second stage: add intermediate sums
                        accum_stage2 <= accum_stage2 + accum_stage1 + data_in;
                        accum_stage1 <= 9'b0; // Clear for next pair
                    end
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule