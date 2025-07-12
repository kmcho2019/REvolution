module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the number of processing elements (PEs) in the systolic array
parameter num_pes = size;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the multiplicand and multiplier
reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;

// declare the registers for the intermediate results
reg [data_width-1:0] intermediate_reg1;
reg [data_width-1:0] intermediate_reg2;

// declare the wires for the connections between PEs
wire [data_width-1:0] partial_product;

// generate the partial products
genvar i;
generate
    for (i = 0; i < num_pes; i++) begin
        // instantiate the PEs
        if (i == 0) begin
            // first PE: multiply and add
            assign partial_product = (multiplier_reg[i] == 1'b1)? {4'b0, multiplicand_reg} : 8'd0;
        end else begin
            // subsequent PEs: add
            assign partial_product = (multiplier_reg[i] == 1'b1)? ({4'b0, multiplicand_reg} << i) : 8'd0;
        end
    end
endgenerate

// declare the adder tree
wire [data_width-1:0] adder_tree_out;

// instantiate the adder tree
adder_tree #(.data_width(data_width)) adder_tree_inst (
    .a(intermediate_reg1),
    .b(partial_product),
    .out(adder_tree_out)
);

// declare the finite state machine (FSM) states
enum logic [1:0] {
    IDLE,
    LOAD_MULTIPLICAND,
    LOAD_MULTIPLIER,
    MULTIPLY,
    ADD_PARTIAL_PRODUCTS,
    OUTPUT_PRODUCT
} state, next_state;

// implement the FSM
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the FSM
        state <= IDLE;
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        intermediate_reg1 <= 8'd0;
        intermediate_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the FSM
        case (state)
            IDLE: begin
                // load the multiplicand and multiplier
                multiplicand_reg <= mul_a;
                multiplier_reg <= mul_b;
                state <= LOAD_MULTIPLICAND;
            end
            LOAD_MULTIPLICAND: begin
                // load the multiplicand into the intermediate register
                intermediate_reg1 <= {4'b0, multiplicand_reg};
                state <= LOAD_MULTIPLIER;
            end
            LOAD_MULTIPLIER: begin
                // load the multiplier into the intermediate register
                intermediate_reg2 <= multiplier_reg;
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                // perform the multiplication operation
                for (int i = 0; i < num_pes; i++) begin
                    if (multiplier_reg[i] == 1'b1) begin
                        intermediate_reg1 <= intermediate_reg1 + ({4'b0, multiplicand_reg} << i);
                    end
                end
                state <= ADD_PARTIAL_PRODUCTS;
            end
            ADD_PARTIAL_PRODUCTS: begin
                // add the partial products
                intermediate_reg1 <= adder_tree_out;
                state <= OUTPUT_PRODUCT;
            end
            OUTPUT_PRODUCT: begin
                // output the final product
                mul_out <= intermediate_reg1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule

// adder tree module
module adder_tree (
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);

// instantiate the adder
assign out = a + b;

endmodule