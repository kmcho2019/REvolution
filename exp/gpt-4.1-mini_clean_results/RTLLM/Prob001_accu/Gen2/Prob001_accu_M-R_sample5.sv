module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] sum_out;
    reg       output_flag;

    // Accumulation and counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
            output_flag <= 1'b0;
        end else begin
            output_flag <= 1'b0; // default no output unless count==4
            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th valid data input
                    sum_out <= accumulator + data_in;
                    output_flag <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

    // Output valid signal and data_out update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= output_flag;
            if (output_flag) begin
                data_out <= sum_out;
            end
        end
    end

endmodule