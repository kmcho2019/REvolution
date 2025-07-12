module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg       flag;       // Indicates first byte stored
    reg [7:0] data_lock;  // Holds first byte

    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag          <= 1'b0;
            data_lock     <= 8'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
            valid_out_next<= 1'b0;
            data_out_next <= 16'd0;
        end else begin
            valid_out     <= valid_out_next;
            data_out      <= data_out_next;
            valid_out_next<= 1'b0; // default clear

            if (valid_in) begin
                if (!flag) begin
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    data_out_next <= {data_lock, data_in};
                    valid_out_next<= 1'b1;
                    flag         <= 1'b0;
                end
            end
        end
    end

endmodule