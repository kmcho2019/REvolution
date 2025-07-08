module width_8to16 (
    input wire        clk,
    input wire        rst_n,
    input wire        valid_in,
    input wire  [7:0] data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'd0;
            flag         <= 1'b0;
            valid_out    <= 1'b0;
            data_out     <= 16'd0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!flag) begin
                    // First valid data: store and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                    // No output yet
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'd0;
                end else begin
                    // Second valid data: concatenate and output next cycle
                    // valid_out and data_out are updated in next cycle via registers
                    valid_out_next <= 1'b1;
                    data_out_next  <= {data_lock, data_in};
                    flag <= 1'b0; // Clear flag after outputting
                end
            end else begin
                // No valid input: clear output valid and keep flag as is
                valid_out_next <= 1'b0;
                data_out_next  <= data_out_next; // hold last value
            end
        end
    end

endmodule