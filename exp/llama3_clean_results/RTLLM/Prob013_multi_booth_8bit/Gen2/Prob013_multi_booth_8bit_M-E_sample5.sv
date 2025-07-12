module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output reg [15:0] p, 
    output reg rdy
);

// Define the states of the FSM
enum logic [1:0] {IDLE, RUNNING, DONE} state;

// Define the pipeline registers
reg [15:0] multiplicand_reg;
reg [15:0] multiplier_reg;
reg [15:0] partial_product_reg;
reg [15:0] product_reg;

// Define the shift registers
reg [15:0] shift_reg1;
reg [15:0] shift_reg2;

// Define the adder and subtractor outputs
wire [15:0] adder_out;
wire [15:0] subtractor_out;

// Define the Booth encoding logic
wire [1:0] booth_encoding;
assign booth_encoding = multiplier_reg[1:0];

// Define the adder and subtractor logic
assign adder_out = multiplicand_reg + shift_reg1;
assign subtractor_out = multiplicand_reg - shift_reg1;

// Define the pipeline logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        multiplicand_reg <= 0;
        multiplier_reg <= 0;
        partial_product_reg <= 0;
        product_reg <= 0;
        shift_reg1 <= 0;
        shift_reg2 <= 0;
        rdy <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (!reset) begin
                    multiplicand_reg <= {{8{b[7]}}, b};
                    multiplier_reg <= {{8{a[7]}}, a};
                    state <= RUNNING;
                end
            end
            RUNNING: begin
                // Shift the multiplicand and multiplier
                shift_reg1 <= multiplicand_reg << 1;
                shift_reg2 <= multiplier_reg << 1;
                
                // Generate the partial product based on the Booth encoding
                case (booth_encoding)
                    2'b00: partial_product_reg <= 0;
                    2'b01: partial_product_reg <= adder_out;
                    2'b10: partial_product_reg <= subtractor_out;
                    2'b11: partial_product_reg <= subtractor_out;
                endcase
                
                // Accumulate the partial product
                product_reg <= product_reg + partial_product_reg;
                
                // Check if the multiplication is complete
                if (multiplier_reg == 0) begin
                    state <= DONE;
                end
            end
            DONE: begin
                p <= product_reg;
                rdy <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule