module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] shift_reg [0:3]; // 4-stage shift register
reg [1:0] counter; // Counter for stack pointer
reg [3:0] dataOut_reg; // Register for output data

assign EMPTY = (counter == 4); // Buffer is empty when counter is 4
assign FULL = (counter == 0); // Buffer is full when counter is 0
assign dataOut = dataOut_reg; // Assign dataOut_reg to output port dataOut

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        counter <= 4; // Initialize counter to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 4'b0; // Initialize shift register to 0
        end
        dataOut_reg <= 4'b0; // Reset dataOut_reg
    end else if (EN) begin // Enable signal is high
        if (~RW) begin // Write operation (RW is low)
            if (~FULL) begin // Buffer is not full
                shift_reg[0] <= dataIn; // Shift data into shift register
                for (int i = 1; i < 4; i++) begin
                    shift_reg[i] <= shift_reg[i-1]; // Shift data in shift register
                end
                counter <= counter - 1; // Decrement counter
            end
        end else begin // Read operation (RW is high)
            if (~EMPTY) begin // Buffer is not empty
                dataOut_reg <= shift_reg[3]; // Shift data out from shift register
                for (int i = 3; i > 0; i--) begin
                    shift_reg[i] <= shift_reg[i-1]; // Shift data in shift register
                end
                shift_reg[0] <= 4'b0; // Clear data in shift register
                counter <= counter + 1; // Increment counter
            end
        end
    end
end

endmodule