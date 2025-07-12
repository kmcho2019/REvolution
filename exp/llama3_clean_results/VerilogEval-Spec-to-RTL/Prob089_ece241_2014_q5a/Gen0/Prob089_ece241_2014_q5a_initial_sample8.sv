module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] counter;  // Counter to keep track of the number of bits received
reg [31:0] input_reg;  // Register to store the input bits
reg add_one;  // Flag to indicate whether we should add 1 to the output
reg [31:0] output_reg;  // Register to store the output bits
reg idle, output_state;  // States of the Moore state machine
reg z_reg;  // Register to store the output

initial begin
    counter = 0;
    input_reg = 0;
    add_one = 0;
    output_reg = 0;
    idle = 1;
    output_state = 0;
    z_reg = 0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0;
        input_reg <= 0;
        add_one <= 0;
        output_reg <= 0;
        idle <= 1;
        output_state <= 0;
        z_reg <= 0;
    end else begin
        if (idle) begin
            if (x == 1) begin
                add_one <= 1;
            end
            input_reg[0] <= ~x;  // Invert the input bit
            counter <= counter + 1;
            idle <= 1;
            if (x == 0) begin
                output_state <= 0;
            end else begin
                output_state <= 1;
            end
        end else if (output_state) begin
            if (counter > 31) begin
                // If we have received more than 32 bits, we can start outputting the 2's complement
                if (add_one) begin
                    output_reg[31] <= 1;  // Add 1 to the output
                end
                z_reg <= output_reg[31];
                output_reg <= output_reg << 1;  // Shift the output register to the left
                counter <= counter - 1;
                if (counter == 0) begin
                    idle <= 1;
                    output_state <= 0;
                end
            end else begin
                input_reg <= {input_reg[30:0], ~x};  // Shift the input register to the left and invert the new input bit
                counter <= counter + 1;
            end
        end
    end
end

assign z = z_reg;

endmodule