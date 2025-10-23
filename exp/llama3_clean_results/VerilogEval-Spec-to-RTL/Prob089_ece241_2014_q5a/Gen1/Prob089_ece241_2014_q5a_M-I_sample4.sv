module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] input_reg;  // Register to store the input bits
reg add_one;  // Flag to indicate whether we should add 1 to the output
reg [31:0] output_reg;  // Register to store the output bits
reg [4:0] counter;  // Counter to keep track of the number of bits received
reg idle;  // State variable to indicate whether we are in the idle state
reg z_reg;  // Register to store the output

initial begin
    input_reg = 0;
    add_one = 0;
    output_reg = 0;
    counter = 0;
    idle = 1;
    z_reg = 0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        input_reg <= 0;
        add_one <= 0;
        output_reg <= 0;
        counter <= 0;
        idle <= 1;
        z_reg <= 0;
    end else begin
        if (idle) begin
            input_reg <= {input_reg[30:0], ~x};  // Shift the input register to the left and invert the new input bit
            if (x == 1) begin
                add_one <= 1;
            end
            counter <= counter + 1;
            if (counter == 32) begin
                idle <= 0;
            end
        end else begin
            if (add_one) begin
                output_reg <= ~input_reg + 1;  // Invert the input register and add 1
            end else begin
                output_reg <= ~input_reg;  // Invert the input register
            end
            z_reg <= output_reg[31];  // Output the most significant bit
            output_reg <= output_reg << 1;  // Shift the output register to the left
            counter <= counter + 1;
            if (counter == 33) begin
                idle <= 1;
                counter <= 0;
            end
        end
    end
end

assign z = z_reg;

endmodule