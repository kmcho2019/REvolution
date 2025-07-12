module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [7:0] shift_reg [0:3];
reg [9:0] sum;
reg [1:0] counter;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 8'd0;
        end
        sum <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            // Shift register update
            for (int i = 3; i > 0; i--) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= data_in;
            
            // Counter update
            counter <= (counter == 2'd3) ? 2'd0 : counter + 1'd1;
            
            // Accumulation using carry-save adder
            if (counter == 2'd3) begin
                sum <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
                valid_out_reg <= 1'b1;
            end else begin
                sum <= 10'd0;
                valid_out_reg <= 1'b0;
            end
        end else begin
            for (int i = 0; i < 4; i++) begin
                shift_reg[i] <= shift_reg[i];
            end
            sum <= sum;
            counter <= counter;
            valid_out_reg <= (valid_out_reg && !valid_in) ? 1'b0 : valid_out_reg;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? sum : 10'd0;

endmodule