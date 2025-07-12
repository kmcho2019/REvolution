module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg        flag;       // indicates if first byte stored
    reg [7:0]  data_lock;  // holds first byte

    reg [15:0] data_out_next;
    reg        valid_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag           <= 1'b0;
            data_lock      <= 8'd0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            valid_out      <= valid_out_next;
            data_out       <= data_out_next;

            valid_out_next <= 1'b0;  // default to no output unless set below

            if (valid_in) begin
                if (!flag) begin
                    // First byte received: store and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second byte received: prepare output next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag           <= 1'b0; // reset flag for next pair
                end
            end
        end
    end

endmodule