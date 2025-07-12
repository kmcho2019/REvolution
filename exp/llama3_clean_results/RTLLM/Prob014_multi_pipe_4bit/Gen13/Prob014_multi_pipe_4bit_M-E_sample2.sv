module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the number of pipeline stages
parameter num_stages = 2;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the multiplicand and multiplier
reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;

// declare the registers for the intermediate results
reg [data_width-1:0] intermediate_reg1;
reg [data_width-1:0] intermediate_reg2;

// declare the counter for the control logic
reg [1:0] counter;

// initialize the counter and registers
initial begin
    counter = 2'b00;
    multiplicand_reg = 4'd0;
    multiplier_reg = 4'd0;
    intermediate_reg1 = 8'd0;
    intermediate_reg2 = 8'd0;
    mul_out = 8'd0;
end

// sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the counter and registers
        counter <= 2'b00;
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        intermediate_reg1 <= 8'd0;
        intermediate_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the counter and registers
        case (counter)
            2'b00: begin
                // load the multiplicand and multiplier
                multiplicand_reg <= mul_a;
                multiplier_reg <= mul_b;
                counter <= 2'b01;
            end
            2'b01: begin
                // calculate the partial products
                intermediate_reg1 <= (multiplier_reg[0] == 1'b1) ? {4'b0, multiplicand_reg} : 8'd0;
                intermediate_reg2 <= (multiplier_reg[1] == 1'b1) ? ({4'b0, multiplicand_reg} << 1) : 8'd0;
                counter <= 2'b10;
            end
            2'b10: begin
                // add the partial products
                mul_out <= intermediate_reg1 + intermediate_reg2 + ((multiplier_reg[2] == 1'b1) ? ({4'b0, multiplicand_reg} << 2) : 8'd0) + ((multiplier_reg[3] == 1'b1) ? ({4'b0, multiplicand_reg} << 3) : 8'd0);
                counter <= 2'b00;
            end
        endcase
    end
end

endmodule