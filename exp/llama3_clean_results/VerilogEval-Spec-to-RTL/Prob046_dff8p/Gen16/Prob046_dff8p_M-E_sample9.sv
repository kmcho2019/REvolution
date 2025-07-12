// Define a parameterized SIPO shift register module with active high synchronous reset
module SIPO_Shift_Register #(parameter RESET_VALUE = 8'h34)( // Parameter for reset value
    input clk,
    input reset,
    input load_reset, // Control signal to load reset value
    input [7:0] d, // Input data
    output [7:0] q // Output data
);

reg [7:0] q_reg;
reg [2:0] counter; // Counter to keep track of shift register position

always @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
        counter <= 0;
    end else if (load_reset) begin
        // Load reset value into shift register
        if (counter == 0) begin
            q_reg[7] <= RESET_VALUE[7];
        end else if (counter == 1) begin
            q_reg[6] <= RESET_VALUE[6];
        end else if (counter == 2) begin
            q_reg[5] <= RESET_VALUE[5];
        end else if (counter == 3) begin
            q_reg[4] <= RESET_VALUE[4];
        end else if (counter == 4) begin
            q_reg[3] <= RESET_VALUE[3];
        end else if (counter == 5) begin
            q_reg[2] <= RESET_VALUE[2];
        end else if (counter == 6) begin
            q_reg[1] <= RESET_VALUE[1];
        end else if (counter == 7) begin
            q_reg[0] <= RESET_VALUE[0];
            counter <= 0; // Reset counter
        end else begin
            counter <= counter + 1;
        end
    end else begin
        // Load input data into shift register
        if (counter == 0) begin
            q_reg[7] <= d[7];
        end else if (counter == 1) begin
            q_reg[6] <= d[6];
        end else if (counter == 2) begin
            q_reg[5] <= d[5];
        end else if (counter == 3) begin
            q_reg[4] <= d[4];
        end else if (counter == 4) begin
            q_reg[3] <= d[3];
        end else if (counter == 5) begin
            q_reg[2] <= d[2];
        end else if (counter == 6) begin
            q_reg[1] <= d[1];
        end else if (counter == 7) begin
            q_reg[0] <= d[0];
            counter <= 0; // Reset counter
        end else begin
            counter <= counter + 1;
        end
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates the SIPO shift register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg load_reset; // Control signal to load reset value

always @(posedge clk) begin
    if (reset) begin
        load_reset <= 1;
    end else begin
        load_reset <= 0;
    end
end

// Instantiate the SIPO shift register with the specified reset value
SIPO_Shift_Register #(.RESET_VALUE(8'h34)) u_sipo_shift_register(
   .clk(clk),
   .reset(reset),
   .load_reset(load_reset),
   .d(d),
   .q(q)
);

endmodule