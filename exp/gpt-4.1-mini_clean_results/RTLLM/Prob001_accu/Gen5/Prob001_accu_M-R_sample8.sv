module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [2:0] count;  // Use 3 bits for easier comparisons, though 2 bits suffice for max 4 count

    // Counting logic: increment count when valid_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (valid_in) begin
            if (count == 3'd3)
                count <= 3'd0;  // Reset count after 4 inputs
            else
                count <= count + 1'b1;
        end
    end

    // Accumulation logic: accumulate data_in when valid_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            accumulator <= 10'd0;
        else if (valid_in) begin
            if (count == 3'd3)
                accumulator <= 10'd0;  // Clear after output
            else
                accumulator <= accumulator + data_in;
        end
    end

    // Output logic: valid_out pulse and data_out register when count reaches 3 (4th input)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in && (count == 3'd3)) begin
                valid_out <= 1'b1;
                data_out <= accumulator + data_in; // final sum of 4 inputs
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule