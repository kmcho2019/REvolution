module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg flag; // Indicates if data_lock holds valid data
reg valid_out_next;
reg [15:0] data_out_next;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        flag <= 1'b0;
        data_out <= 16'd0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= valid_out_next;
        data_out <= data_out_next;
        if (valid_in) begin
            if (flag == 1'b0) begin
                // Store first 8-bit input
                data_lock <= data_in;
                flag <= 1'b1;
            end else begin
                // Concatenate stored data and new data to produce output
                // The first arriving data goes to higher 8 bits
                data_out_next <= {data_lock, data_in};
                valid_out_next <= 1'b1;
                flag <= 1'b0;
            end
        end else begin
            // No valid input, clear output valid signal
            valid_out_next <= 1'b0;
            data_out_next <= data_out;
        end
    end
end

endmodule