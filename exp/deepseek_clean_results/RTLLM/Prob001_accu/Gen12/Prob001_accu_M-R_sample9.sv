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
    wire [9:0] next_accum;  // Next accumulator value
    wire [9:0] final_sum;   // Final sum calculation
    wire count_full;        // Flag when count reaches 3

    // Combinational logic
    assign count_full = (count == 2'b11);
    assign next_accum = accumulator + data_in;
    assign final_sum = accumulator + data_in;

    // Counter sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
        end
        else if (valid_in) begin
            if (count_full) begin
                count <= 2'b00;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end

    // Accumulator sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
        end
        else if (valid_in) begin
            if (count_full) begin
                accumulator <= 10'b0;
            end
            else begin
                accumulator <= next_accum;
            end
        end
    end

    // Output sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in & count_full;
            if (valid_in & count_full) begin
                data_out <= final_sum;
            end
        end
    end

endmodule