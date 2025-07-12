module LIFObuffer #(
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

reg [DATA_WIDTH-1:0] shift_reg [0:BUFFER_SIZE-1]; // Shift register
reg [BUFFER_SIZE-1:0] count; // Counter

// Control logic
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        count <= 0; // Initialize counter to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            shift_reg[i] <= {DATA_WIDTH{1'b0}}; // Initialize shift register to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && count < BUFFER_SIZE) begin // Push operation
            shift_reg[count] <= dataIn; // Push data into shift register
            count <= count + 1; // Increment counter
        end else if (RW && count > 0) begin // Pop operation
            dataOut <= shift_reg[count-1]; // Pop data from shift register
            for (int i = 0; i < BUFFER_SIZE-1; i++) begin
                shift_reg[i] <= shift_reg[i+1]; // Shift data in shift register
            end
            shift_reg[BUFFER_SIZE-1] <= {DATA_WIDTH{1'b0}}; // Clear last element
            count <= count - 1; // Decrement counter
        end
    end
end

// Continuous assignments for EMPTY and FULL flags
assign EMPTY = (count == 0); // Buffer is empty when counter is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when counter is equal to BUFFER_SIZE

endmodule