module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg        flag;        // Indicates if the first byte is stored
    reg [7:0]  data_lock;   // Holds the first byte

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag       <= 1'b0;
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default de-assert output valid each cycle

            if (valid_in) begin
                if (!flag) begin
                    // First byte arrives: store it and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second byte arrives: produce output and clear flag
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag      <= 1'b0;
                end
            end
        end
    end

endmodule