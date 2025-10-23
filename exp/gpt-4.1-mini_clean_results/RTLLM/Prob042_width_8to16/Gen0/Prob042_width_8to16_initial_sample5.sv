module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg flag;            // Indicates that data_lock holds valid data
reg valid_out_next;
reg [15:0] data_out_next;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock    <= 8'd0;
        flag         <= 1'b0;
        data_out     <= 16'd0;
        valid_out    <= 1'b0;
    end else begin
        valid_out <= valid_out_next;
        data_out  <= data_out_next;

        if (valid_in) begin
            if (!flag) begin
                // Store first byte and set flag
                data_lock <= data_in;
                flag      <= 1'b1;
            end else begin
                // Second byte received: produce output next cycle
                // After output, clear flag to wait for next pair
                flag <= 1'b0;
            end
        end
    end
end

// Combinational logic to generate next data_out and valid_out
always @(*) begin
    valid_out_next = 1'b0;
    data_out_next  = data_out;

    if (flag && valid_in) begin
        // When flag is set and new valid_in arrives,
        // output the concatenation in the next cycle
        data_out_next  = {data_lock, data_in};
        valid_out_next = 1'b1;
    end
end

endmodule