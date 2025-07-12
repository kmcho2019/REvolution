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

reg [DATA_WIDTH-1:0] circular_buffer [0:BUFFER_SIZE-1]; // Circular buffer
reg [$clog2(BUFFER_SIZE):0] SP; // Stack pointer for push operations
reg [$clog2(BUFFER_SIZE):0] RP; // Pointer for pop operations

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 0; // Initialize stack pointer
        RP <= 0; // Initialize pop pointer
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            circular_buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize circular buffer
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW) begin // Push operation
            circular_buffer[SP] <= dataIn; // Push data into circular buffer
            SP <= (SP + 1) % BUFFER_SIZE; // Update stack pointer
        end else begin // Pop operation
            dataOut <= circular_buffer[RP]; // Pop data from circular buffer
            circular_buffer[RP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            RP <= (RP + 1) % BUFFER_SIZE; // Update pop pointer
        end
    end
end

// Generate EMPTY and FULL flags based on pointer positions
assign EMPTY = (SP == RP);
assign FULL = ((SP + 1) % BUFFER_SIZE == RP);

endmodule