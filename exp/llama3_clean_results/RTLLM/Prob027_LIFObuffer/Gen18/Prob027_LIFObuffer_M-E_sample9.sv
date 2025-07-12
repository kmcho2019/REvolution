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

reg [DATA_WIDTH-1:0] buffer_mem [0:BUFFER_SIZE-1]; // Circular buffer memory
reg [$clog2(BUFFER_SIZE):0] WP, RP; // Write and Read Pointers
reg [$clog2(BUFFER_SIZE):0] Count; // Number of valid data elements

always @(posedge Clk) begin
    if (Rst) begin
        WP <= 0; // Reset Write Pointer
        RP <= 0; // Reset Read Pointer
        Count <= 0; // Reset Count
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer memory
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && Count < BUFFER_SIZE) begin // Write operation
            buffer_mem[WP] <= dataIn; // Write data to buffer
            WP <= (WP + 1) % BUFFER_SIZE; // Increment Write Pointer
            Count <= Count + 1; // Increment Count
        end else if (RW && Count > 0) begin // Read operation
            dataOut <= buffer_mem[RP]; // Read data from buffer
            buffer_mem[RP] <= {DATA_WIDTH{1'b0}}; // Clear read data
            RP <= (RP + 1) % BUFFER_SIZE; // Increment Read Pointer
            Count <= Count - 1; // Decrement Count
        end
    end
end

// Logic for EMPTY and FULL flags
assign EMPTY = (Count == 0);
assign FULL = (Count == BUFFER_SIZE);

endmodule