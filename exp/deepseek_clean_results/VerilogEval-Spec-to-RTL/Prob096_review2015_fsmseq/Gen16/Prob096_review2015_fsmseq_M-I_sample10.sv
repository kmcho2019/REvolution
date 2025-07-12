module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] shift_reg;
    reg found;
    reg data_reg;
    reg partial_match;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
            data_reg <= 1'b0;
            partial_match <= 1'b0;
            start_shifting <= 1'b0;
        end else if (!found) begin
            // Pipeline stage 1: Register input and check first 3 bits
            data_reg <= data;
            shift_reg <= {shift_reg[2:0], data};
            partial_match <= (shift_reg[2:0] == 3'b110);
            
            // Pipeline stage 2: Check final bit with registered data
            found <= partial_match && data_reg;
            start_shifting <= found;
        end else begin
            start_shifting <= 1'b1;
        end
    end

endmodule