module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accumulator;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 10'b0;
        valid_out <= 1'b0;
        state <= 2'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            accumulator <= accumulator + data_in;
            state <= state + 1'b1;
            
            if (state == 2'b11) begin
                data_out <= accumulator + data_in;
                valid_out <= 1'b1;
                accumulator <= 10'b0;
                state <= 2'b0;
            end
        end
    end
end

endmodule