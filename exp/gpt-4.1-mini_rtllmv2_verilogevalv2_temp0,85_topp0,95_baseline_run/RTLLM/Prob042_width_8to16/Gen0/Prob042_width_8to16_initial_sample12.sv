module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg flag; // indicates if first 8-bit data is stored

    reg valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            flag <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 16'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out <= data_out_next;

            if (valid_in) begin
                if (!flag) begin
                    // store first data_in in data_lock, set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                    valid_out_next <= 1'b0;
                    data_out_next <= 16'b0;
                end else begin
                    // flag=1 means first data stored, now form output with second data_in
                    valid_out_next <= 1'b1;
                    data_out_next <= {data_lock, data_in};
                    flag <= 1'b0;
                end
            end else begin
                // no new input, clear valid_out_next
                valid_out_next <= 1'b0;
                data_out_next <= data_out_next; // hold current data_out_next
            end
        end
    end

endmodule