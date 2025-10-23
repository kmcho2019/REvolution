module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;
    wire [9:0] next_accum = accumulator + data_in;
    wire count_full = (count == 2'd3);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                if (count_full) begin
                    // Output accumulated value and reset
                    data_out <= next_accum;
                    valid_out <= 1'b1;
                    accumulator <= data_in;  // Start new accumulation
                    count <= 2'd1;
                end else begin
                    // Continue accumulation
                    accumulator <= next_accum;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule