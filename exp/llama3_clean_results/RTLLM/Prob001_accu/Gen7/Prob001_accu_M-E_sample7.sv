module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter;
reg [7:0] data_reg1;
reg [7:0] data_reg2;
reg [7:0] data_reg3;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        data_reg1 <= 0;
        data_reg2 <= 0;
        data_reg3 <= 0;
        sum <= 0;
    end else begin
        case (counter)
            0: begin
                if (valid_in) begin
                    data_reg1 <= data_in;
                    counter <= 1;
                end
            end
            1: begin
                if (valid_in) begin
                    data_reg2 <= data_in;
                    counter <= 2;
                end else begin
                    counter <= 0;
                end
            end
            2: begin
                if (valid_in) begin
                    data_reg3 <= data_in;
                    counter <= 3;
                end else begin
                    counter <= 0;
                end
            end
            3: begin
                if (valid_in) begin
                    sum <= data_reg1 + data_reg2 + data_reg3 + data_in;
                    counter <= 0;
                end else begin
                    counter <= 0;
                end
            end
            default: begin
                counter <= 0;
            end
        endcase
    end
end

assign valid_out = (counter == 0) && (sum != 0);
assign data_out = sum;

endmodule