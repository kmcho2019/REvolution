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

// declare the finite state machine (FSM) states
reg [2:0] state;
reg [2:0] next_state;

// implement the FSM
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the FSM
        state <= 3'd0;
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        intermediate_reg1 <= 8'd0;
        intermediate_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the FSM
        case (state)
            3'd0: begin
                // load the multiplicand and multiplier
                multiplicand_reg <= mul_a;
                multiplier_reg <= mul_b;
                state <= 3'd1;
            end
            3'd1: begin
                // initialize the intermediate register
                intermediate_reg1 <= 8'd0;
                state <= 3'd2;
            end
            3'd2: begin
                // perform the multiplication operation
                for (int i = 0; i < size; i++) begin
                    if (multiplier_reg[i] == 1'b1) begin
                        intermediate_reg1 <= intermediate_reg1 + ({4'b0, multiplicand_reg} << i);
                    end
                end
                state <= 3'd3;
            end
            3'd3: begin
                // output the final product
                mul_out <= intermediate_reg1;
                state <= 3'd0;
            end
        endcase
    end
end

endmodule