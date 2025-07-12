module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the multiplicand and multiplier
reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;

// declare the registers for the intermediate results
reg [data_width-1:0] intermediate_reg1;
reg [data_width-1:0] intermediate_reg2;

// declare the wires for the connections
reg [data_width-1:0] partial_product;

// implement the multiplication process
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the registers
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        intermediate_reg1 <= 8'd0;
        intermediate_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // load the multiplicand and multiplier
        multiplicand_reg <= mul_a;
        multiplier_reg <= mul_b;

        // generate partial products and accumulate
        for (int i = 0; i < size; i++) begin
            if (i == 0) begin
                // first clock cycle: generate partial products
                if (multiplier_reg[i] == 1'b1) begin
                    intermediate_reg1 <= {4'b0, multiplicand_reg} << i;
                end else begin
                    intermediate_reg1 <= 8'd0;
                end
            end else begin
                // subsequent clock cycles: accumulate partial products
                if (multiplier_reg[i] == 1'b1) begin
                    intermediate_reg2 <= intermediate_reg1 + ({4'b0, multiplicand_reg} << i);
                end else begin
                    intermediate_reg2 <= intermediate_reg1;
                end
            end
        end

        // update the output
        if (multiplier_reg[size-1] == 1'b1) begin
            mul_out <= intermediate_reg2;
        end else begin
            mul_out <= intermediate_reg1;
        end
    end
end

endmodule