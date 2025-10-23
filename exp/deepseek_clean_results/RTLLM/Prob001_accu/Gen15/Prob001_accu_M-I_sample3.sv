module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator, next_accum;
    wire count_full = &count;  // Efficient full detection (count == 2'b11)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            accumulator <= next_accum;
            
            if (count_full) begin
                data_out <= next_accum;
                valid_out <= 1'b1;
                count <= 2'b0;
            end else begin
                count <= count + 1'b1;
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

    // Combinational next accumulator calculation
    always @(*) begin
        if (!rst_n)
            next_accum = 10'b0;
        else if (valid_in)
            next_accum = accumulator + data_in;
        else
            next_accum = accumulator;
    end

endmodule