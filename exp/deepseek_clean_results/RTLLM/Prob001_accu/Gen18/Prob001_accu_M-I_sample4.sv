module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] sum;
    wire [9:0] next_sum;
    wire count_en;

    // Clock gating control
    assign count_en = valid_in || (count != 0);

    // Pipelined accumulation
    assign next_sum = (count == 0) ? data_in : (sum + data_in);

    // Sequential logic with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            sum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else if (count_en) begin
            if (valid_in) begin
                sum <= next_sum;
                count <= count + 1;
            end

            // Output generation
            if (count == 3 && valid_in) begin
                data_out <= next_sum;
                valid_out <= 1'b1;
                count <= 0;
            end else begin
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule