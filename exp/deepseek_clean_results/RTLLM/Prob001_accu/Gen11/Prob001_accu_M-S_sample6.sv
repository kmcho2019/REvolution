module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg [1:0] count;       // 2-bit counter (0-3)
    reg [9:0] accumulator; // 10-bit accumulator

    assign data_out = accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0; // Default value

            if (valid_in) begin
                if (&count) begin // Terminal count (count == 2'b11)
                    accumulator <= data_in; // Start new accumulation
                    valid_out <= 1'b1;     // Pulse valid_out
                end
                else begin
                    accumulator <= accumulator + data_in;
                end
                count <= count + 1'b1;
            end
        end
    end

endmodule