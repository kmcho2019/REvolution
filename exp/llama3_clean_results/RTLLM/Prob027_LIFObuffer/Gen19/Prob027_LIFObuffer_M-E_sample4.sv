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

reg [DATA_WIDTH-1:0] dual_port_ram [0:BUFFER_SIZE-1]; // Dual-port RAM
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

// Clock gating for dual-port RAM and stack pointer
wire clk_gated;
assign clk_gated = (EN || Rst)? Clk : 1'b0;

// Sequential logic for stack pointer and dataOut
always @(posedge clk_gated) begin
    if (Rst) begin // Active high reset
        SP <= 0; // Initialize stack pointer to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            dual_port_ram[i] <= {DATA_WIDTH{1'b0}}; // Initialize dual-port RAM to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
        EMPTY <= 1'b1; // Initialize EMPTY flag
        FULL <= 1'b0; // Initialize FULL flag
    end else if (EN) begin // Enable signal is high
        if (!RW) begin // Push operation
            if (SP < BUFFER_SIZE) begin
                dual_port_ram[SP] <= dataIn; // Push data onto stack
                SP <= SP + 1; // Increment stack pointer
                EMPTY <= 1'b0; // Update EMPTY flag
                if (SP == BUFFER_SIZE) begin
                    FULL <= 1'b1; // Update FULL flag
                end else begin
                    FULL <= 1'b0; // Update FULL flag
                end
            end
        end else begin // Pop operation
            if (SP > 0) begin
                dataOut <= dual_port_ram[SP-1]; // Pop data from stack
                dual_port_ram[SP-1] <= {DATA_WIDTH{1'b0}}; // Clear popped data
                SP <= SP - 1; // Decrement stack pointer
                FULL <= 1'b0; // Update FULL flag
                if (SP == 0) begin
                    EMPTY <= 1'b1; // Update EMPTY flag
                end else begin
                    EMPTY <= 1'b0; // Update EMPTY flag
                end
            end
        end
    end
end

endmodule