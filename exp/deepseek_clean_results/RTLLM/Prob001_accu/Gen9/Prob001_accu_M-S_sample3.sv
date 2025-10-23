module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg toggle;  // Toggles every 2 inputs (full cycle = 4 inputs)
reg [9:0] sum;  // Accumulator

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            sum <= sum + data_in;
            toggle <= ~toggle;
            
            if (toggle) begin  // Every 2nd input (completes at 4th)
                data_out <= sum + data_in;
                valid_out <= 1'b1;
                sum <= 10'b0;
            end
        end
    end
end

endmodule