module ShiftRegLIFO #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [BUFFER_SIZE*DATA_WIDTH-1:0] shift_reg; // Shift register

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (shift_reg == {BUFFER_SIZE*DATA_WIDTH{1'b0}}); // Buffer is empty when shift register is all zeros
assign FULL = (shift_reg == {BUFFER_SIZE*DATA_WIDTH{1'b1}}); // Buffer is full when shift register is all ones

// Sequential logic for shift register
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        shift_reg <= {BUFFER_SIZE*DATA_WIDTH{1'b0}}; // Initialize shift register to all zeros
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            shift_reg <= {dataIn, shift_reg[BUFFER_SIZE*DATA_WIDTH-1:DATA_WIDTH]}; // Shift data to the right
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= shift_reg[DATA_WIDTH-1:0]; // Pop data from the left
            shift_reg <= {shift_reg[BUFFER_SIZE*DATA_WIDTH-1:DATA_WIDTH], {DATA_WIDTH{1'b0}}}; // Shift data to the left
        end
    end
end

endmodule