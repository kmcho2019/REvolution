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

// Control unit
reg [BUFFER_SIZE-1:0] count; // Count of valid entries in the buffer
reg shift_en; // Shift enable signal

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        count <= 0;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            shift_reg[i] <= {DATA_WIDTH{1'b0}};
        end
    end else if (EN) begin // Enable signal is high
        if (!RW && count < BUFFER_SIZE) begin // Write operation
            shift_reg[0] <= dataIn; // Shift data into first flip-flop
            for (int i = 1; i < BUFFER_SIZE; i++) begin
                shift_reg[i] <= shift_reg[i-1]; // Shift existing data
            end
            count <= count + 1;
        end else if (RW && count > 0) begin // Read operation
            dataOut <= shift_reg[BUFFER_SIZE-1]; // Shift data out from last flip-flop
            for (int i = BUFFER_SIZE-1; i > 0; i--) begin
                shift_reg[i] <= shift_reg[i-1]; // Shift existing data
            end
            shift_reg[0] <= {DATA_WIDTH{1'b0}};
            count <= count - 1;
        end
    end
end

// Flag generation
always @(*) begin
    EMPTY = (count == 0);
    FULL = (count == BUFFER_SIZE);
end

endmodule