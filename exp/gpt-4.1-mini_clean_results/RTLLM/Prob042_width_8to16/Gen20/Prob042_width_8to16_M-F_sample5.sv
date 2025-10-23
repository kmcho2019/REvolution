module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output reg     valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;  // store first byte
    reg flag;             // 0: waiting for first byte, 1: first byte stored

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'd0;
            flag      <= 1'b0;
            valid_out <= 1'b0;
            data_out  <= 16'd0;
        end else begin
            valid_out <= 1'b0;  // default deassert valid_out each cycle unless set below

            if (!flag) begin
                // Waiting for first byte
                if (valid_in) begin
                    data_lock <= data_in;
                    flag <= 1'b1;
                end
            end else begin
                // flag==1 means first byte stored, waiting for second byte
                if (valid_in) begin
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag <= 1'b0; // reset flag to wait for next pair
                end
                // if no valid_in, keep flag=1 and no output
            end
        end
    end

endmodule