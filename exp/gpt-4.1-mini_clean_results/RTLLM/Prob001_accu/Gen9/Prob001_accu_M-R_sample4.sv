module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] sum_reg;

    // Accumulate inputs when valid_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            sum_reg     <= 10'd0;
        end else if (valid_in) begin
            accumulator <= accumulator + data_in;
            count       <= count + 1'b1;

            if (count == 2'd3) begin
                // Store final sum for output
                sum_reg <= accumulator + data_in;
                accumulator <= 10'd0;
                count <= 2'd0;
            end
        end
    end

    // Output logic and valid_out generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            if (count == 2'd0 && valid_in) begin
                // Valid sum is ready this cycle
                data_out  <= sum_reg;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule