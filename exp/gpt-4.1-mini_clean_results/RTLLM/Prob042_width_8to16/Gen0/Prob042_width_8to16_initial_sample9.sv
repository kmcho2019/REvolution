module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag_first_data;  // Indicates first data stored

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'b0;
            data_out     <= 16'b0;
            valid_out    <= 1'b0;
            flag_first_data <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // Default no output valid this cycle
            if (valid_in) begin
                if (!flag_first_data) begin
                    // First valid input: store and set flag
                    data_lock      <= data_in;
                    flag_first_data <= 1'b1;
                end else begin
                    // Second valid input: concatenate stored and current input
                    data_out     <= {data_lock, data_in};
                    valid_out    <= 1'b1;
                    flag_first_data <= 1'b0;
                end
            end
        end
    end

endmodule