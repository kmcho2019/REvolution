module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_latched;
    reg [9:0] accumulator;
    reg [1:0] count;  // counts from 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_latched <= 8'd0;
            accumulator  <= 10'd0;
            count        <= 2'd0;
            data_out     <= 10'd0;
            valid_out    <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no output

            // Latch data_in when valid_in asserted
            if (valid_in) begin
                data_latched <= data_in;

                // Add latched data to accumulator
                accumulator <= accumulator + data_in;

                // Increment count
                if (count == 2'd3) begin
                    // On 4th valid input
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule