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

reg [DATA_WIDTH-1:0] buffer [0:BUFFER_SIZE-1]; // Circular buffer
reg [1:0] WP; // Write pointer
reg [1:0] RP; // Read pointer

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        WP <= 0; // Initialize write pointer
        RP <= 0; // Initialize read pointer
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW &&!FULL) begin // Push operation
            buffer[WP] <= dataIn; // Write data to buffer
            WP <= (WP + 1) % BUFFER_SIZE; // Increment write pointer
        end else if (RW &&!EMPTY) begin // Pop operation
            dataOut <= buffer[RP]; // Read data from buffer
            buffer[RP] <= {DATA_WIDTH{1'b0}}; // Clear read data
            RP <= (RP + 1) % BUFFER_SIZE; // Increment read pointer
        end
    end
end

assign EMPTY = (WP == RP) && (buffer[RP] == {DATA_WIDTH{1'b0}}); // Buffer is empty when WP equals RP and data at RP is 0
assign FULL = (WP == RP) && (buffer[RP]!= {DATA_WIDTH{1'b0}}); // Buffer is full when WP equals RP and data at RP is not 0

endmodule