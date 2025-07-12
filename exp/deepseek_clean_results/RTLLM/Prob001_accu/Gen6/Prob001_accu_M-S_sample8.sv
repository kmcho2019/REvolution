module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            accumulator <= 0;
            valid_out <= 0;
        end
        else begin
            valid_out <= 0;
            
            if (valid_in) begin
                accumulator <= accumulator + data_in;
                
                if (count == 3) begin
                    data_out <= accumulator + data_in;
                    valid_out <= 1;
                    accumulator <= 0;
                    count <= 0;
                end
                else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule