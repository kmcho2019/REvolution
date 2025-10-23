module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [7:0] shift_reg [3:0];
reg [1:0] cnt_reg;
reg [9:0] sum_reg;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_reg <= 2'd0;
        valid_out_reg <= 1'b0;
        sum_reg <= 10'd0;
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 8'd0;
        end
    end else begin
        if (valid_in) begin
            if (cnt_reg == 2'd3) begin
                // Calculate sum and output
                sum_reg <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
                valid_out_reg <= 1'b1;
                // Reset shift register and counter
                cnt_reg <= 2'd0;
                for (int i = 0; i < 4; i++) begin
                    shift_reg[i] <= (i == 0) ? data_in : 8'd0;
                end
            end else begin
                // Shift data into shift register
                for (int i = 3; i > 0; i--) begin
                    shift_reg[i] <= shift_reg[i-1];
                end
                shift_reg[0] <= data_in;
                cnt_reg <= cnt_reg + 1'd1;
                valid_out_reg <= 1'b0;
            end
        end else begin
            cnt_reg <= cnt_reg;
            valid_out_reg <= (valid_out_reg && !valid_in) ? 1'b0 : valid_out_reg;
            sum_reg <= sum_reg;
            for (int i = 0; i < 4; i++) begin
                shift_reg[i] <= shift_reg[i];
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? sum_reg : 10'd0;

endmodule