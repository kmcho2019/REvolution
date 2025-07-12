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

    wire [9:0] acc_next;

    // Compute next accumulator value if valid_in asserted
    assign acc_next = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            sum_reg     <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default

            if (valid_in) begin
                accumulator <= acc_next;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    sum_reg <= acc_next;  // final sum of 4 inputs
                    data_out <= acc_next;
                    valid_out <= 1'b1;

                    // Reset accumulator and count for next batch
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule