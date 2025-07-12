module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;      // Stores first 8-bit data
    reg flag;                 // Indicates if first data is stored
    reg valid_out_next;       // Delayed valid_out signal
    reg [15:0] data_out_next; // Delayed output data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'd0;
            flag <= 1'b0;
            data_out <= 16'd0;
            valid_out <= 1'b0;
            data_out_next <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out <= data_out_next;

            valid_out_next <= 1'b0;  // Default no valid output unless set below

            if (valid_in) begin
                if (!flag) begin
                    // Store first input and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second input arrived, prepare output next cycle
                    data_out_next <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag <= 1'b0; // Clear flag after output is prepared
                end
            end
            // If no valid_in, keep flag and data_lock unchanged,
            // and no valid output generated
        end
    end

endmodule