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
    wire [9:0] next_accum = valid_in ? accumulator + data_in : accumulator;
    wire count_full = (count == 2'd3);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                if (count_full) begin
                    count <= 2'b0;
                    accumulator <= data_in; // Start new accumulation
                    data_out <= next_accum;
                end else begin
                    count <= count + 1'b1;
                    accumulator <= next_accum;
                end
            end
            
            // Registered valid_out generation
            valid_out <= valid_in & count_full;
        end
    end

endmodule