module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [7:0] data_buffer [3:0];
    reg [1:0] ptr; // pointer to count stored inputs (0-3)

    integer i;
    reg [9:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
            for (i=0; i<4; i=i+1) begin
                data_buffer[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default no valid out

            if (valid_in) begin
                // Store incoming data into buffer at current pointer
                data_buffer[ptr] <= data_in;
                if (ptr == 2'd3) begin
                    // If buffer full after this input, sum all entries
                    sum = data_in;
                    for (i=0; i<3; i=i+1) begin
                        sum = sum + data_buffer[i];
                    end
                    data_out <= sum;
                    valid_out <= 1'b1;
                    ptr <= 2'd0; // reset pointer after output
                end else begin
                    ptr <= ptr + 1'b1; // advance pointer
                end
            end
        end
    end

endmodule