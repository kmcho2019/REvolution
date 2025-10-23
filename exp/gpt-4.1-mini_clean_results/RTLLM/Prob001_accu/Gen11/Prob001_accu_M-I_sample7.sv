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

    // Registers to hold output data and valid signal for one-cycle pulse
    reg [9:0] data_out_reg;
    reg       valid_out_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator    <= 10'd0;
            count          <= 2'd0;
            data_out_reg   <= 10'd0;
            valid_out_reg  <= 1'b0;
            data_out       <= 10'd0;
            valid_out      <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0;  // Default to 0 each cycle
            if (valid_in) begin
                if (count == 2'd3) begin
                    // Accumulate last data and prepare output
                    data_out_reg  <= accumulator + data_in;
                    valid_out_reg <= 1'b1;
                    accumulator   <= 10'd0;
                    count         <= 2'd0;
                end else begin
                    accumulator <= accumulator + data_in;
                    count       <= count + 1'b1;
                end
            end
            // Register outputs (pipeline stage)
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule