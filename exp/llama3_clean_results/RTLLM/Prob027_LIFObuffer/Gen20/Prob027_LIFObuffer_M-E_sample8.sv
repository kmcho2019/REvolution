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
reg [BUFFER_SIZE-1:0] WP; // Write pointer
reg [BUFFER_SIZE-1:0] RP; // Read pointer

// Combinational logic for next write pointer value
wire [BUFFER_SIZE-1:0] next_WP;
assign next_WP = (Rst) ? 0 :
                 (EN && !RW) ? (WP + 1) % BUFFER_SIZE :
                 WP;

// Combinational logic for next read pointer value
wire [BUFFER_SIZE-1:0] next_RP;
assign next_RP = (Rst) ? 0 :
                 (EN && RW) ? (RP + 1) % BUFFER_SIZE :
                 RP;

// Sequential logic for write pointer, read pointer, and buffer memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        WP <= 0; // Initialize write pointer to 0
        RP <= 0; // Initialize read pointer to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        WP <= next_WP; // Update write pointer
        RP <= next_RP; // Update read pointer
        if (!RW) begin // Write operation
            buffer_mem[WP] <= dataIn; // Write data to buffer
        end else begin // Read operation
            dataOut <= buffer_mem[RP]; // Read data from buffer
        end
    end
end

// Continuous assignments for EMPTY and FULL flags
assign EMPTY = (WP == RP); // Buffer is empty when WP equals RP
assign FULL = ((WP + 1) % BUFFER_SIZE == RP); // Buffer is full when (WP + 1) mod BUFFER_SIZE equals RP

endmodule