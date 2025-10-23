module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] count;
reg [7:0] data_reg [3:0];
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        data_reg[0] <= 0;
        data_reg[1] <= 0;
        data_reg[2] <= 0;
        data_reg[3] <= 0;
        sum <= 0;
    end else begin
        if (valid_in) begin
            case (count)
                0: begin
                    data_reg[0] <= data_in;
                    count <= count + 1;
                end
                1: begin
                    data_reg[1] <= data_in;
                    count <= count + 1;
                end
                2: begin
                    data_reg[2] <= data_in;
                    count <= count + 1;
                end
                3: begin
                    data_reg[3] <= data_in;
                    sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                    count <= 0;
                end
            endcase
        end else begin
            count <= 0;
            data_reg[0] <= 0;
            data_reg[1] <= 0;
            data_reg[2] <= 0;
            data_reg[3] <= 0;
            sum <= 0;
        end
    end
end

assign valid_out = (count == 0) && (sum!= 0);
assign data_out = sum;

endmodule