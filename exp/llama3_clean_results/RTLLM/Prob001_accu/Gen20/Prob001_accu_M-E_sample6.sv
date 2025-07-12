module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] shift_reg [0:3];
reg [1:0] state_reg;
wire [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 0;
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 0;
        end
    end else if (valid_in) begin
        // Shift in new data
        for (int i = 3; i > 0; i--) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= data_in;
        
        // Update state
        if (state_reg == 0) begin
            state_reg <= state_reg + 1;
        end else if (state_reg == 3) begin
            state_reg <= 0;
        end else begin
            state_reg <= state_reg + 1;
        end
    end
end

// Adder tree to sum the values in the shift register
assign sum = (shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3]);

// Output logic
assign valid_out = (state_reg == 0 && valid_in);
assign data_out = sum;

endmodule