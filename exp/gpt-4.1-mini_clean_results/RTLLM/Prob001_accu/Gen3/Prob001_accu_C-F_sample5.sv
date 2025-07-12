module accu (
    input              clk,
    input              rst_n,
    input       [7:0]  data_in,
    input              valid_in,
    output reg         valid_out,
    output reg [9:0]   data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;         // 2-bit counter for counting 0 to 3

    wire [9:0] next_accum;
    assign next_accum = accumulator + data_in;

    // Accumulator and counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
        end else if (valid_in) begin
            if (count == 2'd3) begin
                // Fourth input received: reset accumulator and count
                accumulator <= 10'd0;
                count <= 2'd0;
            end else begin
                accumulator <= next_accum;
                count <= count + 1'b1;
            end
        end
    end

    // Output logic with single-cycle valid_out pulse
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default low each cycle
            if (valid_in && (count == 2'd3)) begin
                // On receiving the fourth data input, output the sum
                data_out <= next_accum;
                valid_out <= 1'b1;
            end
        end
    end

endmodule