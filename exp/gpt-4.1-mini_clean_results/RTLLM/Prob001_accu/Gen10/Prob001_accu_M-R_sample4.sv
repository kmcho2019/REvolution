module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [2:0] count;          // Use 3 bits for clarity (counts 0 to 4)
    reg       output_trigger; // Indicates when output should be valid

    // Next accumulator value (combinational)
    wire [9:0] acc_next = accumulator + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator    <= 10'd0;
            count          <= 3'd0;
            data_out       <= 10'd0;
            valid_out      <= 1'b0;
            output_trigger <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default low each cycle

            if (valid_in) begin
                if (count == 3'd3) begin
                    // On receiving 4th valid input: output and reset
                    data_out       <= acc_next;
                    valid_out      <= 1'b1;
                    accumulator    <= 10'd0;
                    count          <= 3'd0;
                    output_trigger <= 1'b1;
                end else begin
                    // Accumulate and increment count
                    accumulator <= acc_next;
                    count       <= count + 1'b1;
                    output_trigger <= 1'b0;
                end
            end else begin
                // When no valid_in, maintain state and no output
                output_trigger <= 1'b0;
                valid_out <= 1'b0;
            end
        end
    end

endmodule