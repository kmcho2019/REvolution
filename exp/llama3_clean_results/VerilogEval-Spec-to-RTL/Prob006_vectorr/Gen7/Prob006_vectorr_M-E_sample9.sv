// Module to reverse the bit ordering of an 8-bit input using a counter and register
module TopModule(
    input  clk,  // Clock signal
    input  rst_n,  // Active low reset
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out  // 8-bit output vector
);

    reg [7:0] input_reg;  // Register to hold the input value
    reg [2:0] counter;  // Counter to iterate through the bits in reverse order
    reg [7:0] out_reg;  // Register to hold the output value

    // Combinational logic to assign the correct bit from the input to the output
    always @(*) begin
        case (counter)
            3'b000: out_reg[7] = input_reg[0];
            3'b001: out_reg[6] = input_reg[1];
            3'b010: out_reg[5] = input_reg[2];
            3'b011: out_reg[4] = input_reg[3];
            3'b100: out_reg[3] = input_reg[4];
            3'b101: out_reg[2] = input_reg[5];
            3'b110: out_reg[1] = input_reg[6];
            3'b111: out_reg[0] = input_reg[7];
            default: out_reg = 8'b0;
        endcase
    end

    // Sequential logic to update the counter and registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'b000;
            input_reg <= 8'b0;
            out_reg <= 8'b0;
        end else begin
            input_reg <= in;  // Load the input into the register
            if (counter == 3'b111) begin
                counter <= 3'b000;  // Reset the counter when it reaches the end
            end else begin
                counter <= counter + 1'b1;  // Increment the counter
            end
        end
    end

    // Assign the output from the register
    assign out = out_reg;

endmodule