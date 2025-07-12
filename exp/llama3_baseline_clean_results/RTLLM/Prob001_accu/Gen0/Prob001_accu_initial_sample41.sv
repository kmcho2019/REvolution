module accu(
    input         clk,        // Clock input for synchronization
    input         rst_n,      // Active-low reset signal
    input  [7:0]  data_in,    // 8-bit input data for addition
    input         valid_in,   // Input signal indicating readiness for new data
    output        valid_out,  // Output signal indicating when 4 input data accumulation is reached
    output [9:0]  data_out    // 10-bit output data representing the accumulated sum
);

reg [9:0]  accu_reg;          // Register to store the accumulated sum
reg [1:0]  cnt_reg;           // Counter to keep track of the number of valid input data
reg [7:0]  data_reg [0:3];    // Registers to store the input data temporarily
reg        valid_out_reg;     // Register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg <= 10'd0;
        cnt_reg <= 2'd0;
        valid_out_reg <= 1'b0;
        for (int i = 0; i < 4; i++) begin
            data_reg[i] <= 8'd0;
        end
    end else if (valid_in) begin
        if (cnt_reg < 2'd3) begin
            data_reg[cnt_reg] <= data_in;
            cnt_reg <= cnt_reg + 1'd1;
        end else if (cnt_reg == 2'd3) begin
            data_reg[3] <= data_in;
            accu_reg <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
            valid_out_reg <= 1'b1;
            cnt_reg <= 2'd0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

always @(*) begin
    valid_out = valid_out_reg;
    data_out = accu_reg;
end

endmodule