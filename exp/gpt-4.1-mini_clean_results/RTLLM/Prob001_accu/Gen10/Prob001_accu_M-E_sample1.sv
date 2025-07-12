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
    reg [9:0] output_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            output_reg  <= 10'd0;
            valid_out   <= 1'b0;
            data_out    <= 10'd0;
        end else begin
            valid_out <= 1'b0; // default low
            if (valid_in) begin
                if (count == 2'd3) begin
                    // 4th valid input received: accumulate, output, reset
                    accumulator <= 10'd0;
                    count <= 2'd0;
                    output_reg <= accumulator + data_in;
                    valid_out <= 1'b1;
                end else begin
                    // Accumulate inputs and increment counter
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end

            // Register output data one cycle after accumulation completed
            if (valid_out) begin
                data_out <= output_reg;
            end
        end
    end

endmodule