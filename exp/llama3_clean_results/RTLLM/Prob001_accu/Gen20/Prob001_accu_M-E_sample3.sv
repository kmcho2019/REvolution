module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] count;
reg [7:0] shift_reg [3:0];
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 0;
        end
        sum <= 0;
    end else begin
        if (valid_in) begin
            // Shift in new data
            for (int i = 3; i > 0; i--) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= data_in;
            count <= count + 1;
        end
        
        // If shift register is full, compute sum and reset
        if (count == 4) begin
            sum <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
            count <= 0;
            for (int i = 0; i < 4; i++) begin
                shift_reg[i] <= 0;
            end
        end
    end
end

assign valid_out = (count == 0) && (sum != 0);
assign data_out = sum;

endmodule