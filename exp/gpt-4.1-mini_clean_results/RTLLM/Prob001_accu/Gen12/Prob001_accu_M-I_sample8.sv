module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [2:0] count;  // 3-bit counter counts 0 to 3

    // Accumulate only when valid_in is asserted
    wire update_en = valid_in;

    // Next accumulator value (combinational)
    wire [9:0] acc_next = accumulator + data_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 3'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default deassert

            if (update_en) begin
                if (count == 3'd3) begin
                    // On 4th input: output sum + input, pulse valid_out
                    data_out  <= acc_next;
                    valid_out <= 1'b1;

                    // Reset accumulator and counter for next group
                    accumulator <= 10'd0;
                    count       <= 3'd0;
                end else begin
                    // Accumulate data_in
                    accumulator <= acc_next;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule