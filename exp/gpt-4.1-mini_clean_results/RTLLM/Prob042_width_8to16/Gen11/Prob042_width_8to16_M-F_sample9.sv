module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;         // stores the first 8-bit input
    reg        flag;              // 0: no first data stored; 1: first data stored waiting for second

    // Pipeline registers to produce output one cycle after second input arrives
    reg [15:0] data_out_next;
    reg        valid_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            flag           <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            // Default output valid cleared each cycle; set below if valid data ready
            valid_out <= valid_out_next;
            data_out  <= data_out_next;
            valid_out_next <= 1'b0; // clear next-cycle valid by default

            if (valid_in) begin
                if (flag == 1'b0) begin
                    // First valid input: store data_in and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second valid input: concatenate with stored data and prepare output
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag <= 1'b0;  // reset flag for next pair
                end
            end
        end
    end

endmodule