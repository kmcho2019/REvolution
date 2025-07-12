module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    reg        first_data_flag;   // Indicates if first 8-bit data is stored
    reg [7:0]  data_lock;         // Stores first 8-bit input data

    reg        valid_out_reg;
    reg [15:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data_flag <= 1'b0;
            data_lock       <= 8'd0;
            valid_out_reg   <= 1'b0;
            data_out_reg    <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0;  // default: no output this cycle

            if (valid_in) begin
                if (!first_data_flag) begin
                    // Store first byte and set flag
                    data_lock       <= data_in;
                    first_data_flag <= 1'b1;
                end else begin
                    // Second byte arrived: concatenate and output next cycle
                    data_out_reg    <= {data_lock, data_in};
                    valid_out_reg   <= 1'b1;
                    first_data_flag <= 1'b0;
                end
            end
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule