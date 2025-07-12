module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [1:0]  count;
    reg [9:0]  sum;

    reg [1:0]  next_count;
    reg [9:0]  next_sum;
    reg        next_valid_out;
    reg [9:0]  next_data_out;

    // Combinational logic for next state and outputs
    always @(*) begin
        next_count      = count;
        next_sum        = sum;
        next_valid_out  = 1'b0;
        next_data_out   = data_out;

        if (valid_in) begin
            if (count == 2'd3) begin
                // Final accumulation and output
                next_data_out  = sum + data_in;
                next_valid_out = 1'b1;
                next_sum       = 10'd0;
                next_count     = 2'd0;
            end else begin
                // Accumulate and increment count
                next_sum   = sum + data_in;
                next_count = count + 1'b1;
            end
        end
    end

    // Sequential logic for registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            sum       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            count     <= next_count;
            sum       <= next_sum;
            data_out  <= next_data_out;
            valid_out <= next_valid_out;
        end
    end

endmodule