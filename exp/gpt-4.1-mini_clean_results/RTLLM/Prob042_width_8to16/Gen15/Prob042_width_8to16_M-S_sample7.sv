module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;   // store first byte
    reg       have_first;  // flag indicating stored first byte

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            have_first <= 1'b0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            valid_out <= 1'b0;    // default no valid output

            if (valid_in) begin
                if (!have_first) begin
                    data_lock  <= data_in;
                    have_first <= 1'b1;
                end else begin
                    data_out   <= {data_lock, data_in};
                    valid_out  <= 1'b1;
                    have_first <= 1'b0;
                end
            end
        end
    end

endmodule