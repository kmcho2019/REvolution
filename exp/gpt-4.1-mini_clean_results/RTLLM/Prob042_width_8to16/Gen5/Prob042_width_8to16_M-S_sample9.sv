module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       has_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            has_data   <= 1'b0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default output invalid

            if (valid_in) begin
                if (!has_data) begin
                    // store first byte, wait for second
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // second byte arrived, output concatenated data next cycle
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    has_data  <= 1'b0;
                end
            end
        end
    end

endmodule