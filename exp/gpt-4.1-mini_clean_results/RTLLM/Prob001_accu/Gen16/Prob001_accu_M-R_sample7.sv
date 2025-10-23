module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;

    // Count valid inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 2'd0;
        else if (valid_in) begin
            if (count == 2'd3)
                count <= 2'd0;
            else
                count <= count + 1'b1;
        end
    end

    // Accumulate input data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            accumulator <= 10'd0;
        else if (valid_in) begin
            if (count == 2'd3)
                accumulator <= 10'd0;
            else
                accumulator <= accumulator + data_in;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;
            if (valid_in && (count == 2'd3)) begin
                data_out  <= accumulator + data_in; // sum of 4 inputs
                valid_out <= 1'b1;
            end
        end
    end

endmodule