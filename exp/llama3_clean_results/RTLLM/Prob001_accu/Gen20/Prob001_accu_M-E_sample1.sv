module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] count;
reg [7:0] buffer [0:3];
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        sum <= 0;
        for (int i = 0; i < 4; i++) begin
            buffer[i] <= 0;
        end
    end else begin
        if (valid_in) begin
            buffer[count] <= data_in;
            if (count == 3) begin
                sum <= buffer[0] + buffer[1] + buffer[2] + buffer[3];
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end else begin
            count <= 0;
        end
    end
end

assign valid_out = (count == 0) && (sum != 0);
assign data_out = sum;

endmodule