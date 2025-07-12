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
    reg [9:0] accumulator_next;

    // Update registers only when valid_in is high (clock enable)
    wire acc_en = valid_in;

    always @(*) begin
        if (count == 2'd3) begin
            // On 4th data, accumulator_next is sum including current data_in
            accumulator_next = accumulator + data_in;
        end else begin
            // Otherwise accumulate current data_in
            accumulator_next = accumulator + data_in;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no valid output

            if (acc_en) begin
                if (count == 2'd3) begin
                    // Output result on this cycle
                    data_out  <= accumulator_next;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    accumulator <= accumulator_next;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule