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
reg [2:0] counter;

// initialize the counter and registers
initial begin
    counter = 3'b000;
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
        counter <= 3'b000;
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        intermediate_reg1 <= 8'd0;
        intermediate_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the counter and registers
        case (counter)
            3'b000: begin
                // load the multiplicand and multiplier
                multiplicand_reg <= mul_a;
                multiplier_reg <= mul_b;
                counter <= 3'b001;
            end
            3'b001: begin
                // calculate the first partial product
                intermediate_reg1 <= (multiplier_reg[0] == 1'b1) ? {4'b0, multiplicand_reg} : 8'd0;
                counter <= 3'b010;
            end
            3'b010: begin
                // calculate the second partial product
                intermediate_reg2 <= intermediate_reg1 + ((multiplier_reg[1] == 1'b1) ? ({4'b0, multiplicand_reg} << 1) : 8'd0);
                counter <= 3'b011;
            end
            3'b011: begin
                // calculate the third partial product
                intermediate_reg1 <= intermediate_reg2 + ((multiplier_reg[2] == 1'b1) ? ({4'b0, multiplicand_reg} << 2) : 8'd0);
                counter <= 3'b100;
            end
            3'b100: begin
                // calculate the fourth partial product
                mul_out <= intermediate_reg1 + ((multiplier_reg[3] == 1'b1) ? ({4'b0, multiplicand_reg} << 3) : 8'd0);
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule