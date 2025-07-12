module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;    // Holds first valid input
    reg       flag;         // Indicates if data_lock holds valid data
    reg       out_flag;     // Indicates output valid next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            flag       <= 1'b0;
            out_flag   <= 1'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            valid_out <= 1'b0;  // Default no valid output unless set below
            
            if (out_flag) begin
                // On the cycle after second data input, output data_out and valid_out
                valid_out <= 1'b1;
                out_flag  <= 1'b0;
            end

            if (valid_in) begin
                if (!flag) begin
                    // First valid data input arrives: store it
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second valid data input arrives: concatenate and schedule output next cycle
                    data_out <= {data_lock, data_in}; // first input high byte, second low byte
                    out_flag <= 1'b1;
                    flag     <= 1'b0; // Clear flag to wait for next pair
                end
            end
        end
    end

endmodule