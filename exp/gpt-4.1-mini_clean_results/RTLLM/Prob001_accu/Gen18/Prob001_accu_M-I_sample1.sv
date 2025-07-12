module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;       // Holds running sum
    reg [1:0] count;             // Counts from 0 to 3
    reg [9:0] output_reg;        // Registered output sum
    reg       valid_out_reg;     // Registered valid output

    wire accum_ce = valid_in;    // Clock enable for accumulation and count

    // Next value of accumulator
    wire [9:0] accumulator_next = accumulator + {2'b00, data_in}; // zero-extend data_in to 10 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator   <= 10'd0;
            count         <= 2'd0;
            output_reg    <= 10'd0;
            valid_out_reg <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0;  // Default to 0 each cycle

            if (accum_ce) begin
                if (count == 2'd3) begin
                    // On 4th input, accumulate and output sum next cycle
                    output_reg    <= accumulator_next;
                    valid_out_reg <= 1'b1;
                    accumulator   <= 10'd0;
                    count         <= 2'd0;
                end else begin
                    accumulator <= accumulator_next;
                    count       <= count + 1'b1;
                end
            end
        end
    end

    // Output registers updated combinationally from registered signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            data_out  <= output_reg;
            valid_out <= valid_out_reg;
        end
    end

endmodule