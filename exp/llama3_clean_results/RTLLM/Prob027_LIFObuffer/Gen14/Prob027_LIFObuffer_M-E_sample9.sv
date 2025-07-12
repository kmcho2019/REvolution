module HybridLIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4,
    parameter SRU_DEPTH = 2 // Depth of the Shift Register Unit
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

// Shift Register Unit (SRU)
reg [DATA_WIDTH-1:0] sru_reg [0:SRU_DEPTH-1];
reg [DATA_WIDTH-1:0] sru_out;

// Dual-Port RAM Unit (DPRU)
reg [DATA_WIDTH-1:0] dpru_ram [0:BUFFER_SIZE-SRU_DEPTH-1];
reg [DATA_WIDTH-1:0] dpru_out;

// Control Unit
reg [1:0] ctrl_state; // 0: IDLE, 1: PUSH, 2: POP
reg [BUFFER_SIZE-1:0] dpru_addr;

// Combinational Logic
assign EMPTY = (ctrl_state == 2'b00);
assign FULL = (ctrl_state == 2'b11);

// Sequential Logic
always @(posedge Clk) begin
    if (Rst) begin
        // Initialize SRU and DPRU
        for (int i = 0; i < SRU_DEPTH; i++) begin
            sru_reg[i] <= {DATA_WIDTH{1'b0}};
        end
        for (int i = 0; i < BUFFER_SIZE-SRU_DEPTH; i++) begin
            dpru_ram[i] <= {DATA_WIDTH{1'b0}};
        end
        ctrl_state <= 2'b00;
        dpru_addr <= {BUFFER_SIZE{1'b0}};
    end else if (EN) begin
        case (ctrl_state)
            2'b00: begin // IDLE
                if (RW && !FULL) begin
                    // Push data into SRU
                    for (int i = SRU_DEPTH-1; i > 0; i--) begin
                        sru_reg[i] <= sru_reg[i-1];
                    end
                    sru_reg[0] <= dataIn;
                    ctrl_state <= 2'b01;
                end else if (!RW && !EMPTY) begin
                    // Pop data from SRU
                    dataOut <= sru_reg[SRU_DEPTH-1];
                    for (int i = SRU_DEPTH-1; i > 0; i--) begin
                        sru_reg[i] <= sru_reg[i-1];
                    end
                    sru_reg[0] <= {DATA_WIDTH{1'b0}};
                    ctrl_state <= 2'b00;
                end
            end
            2'b01: begin // PUSH
                // Push data from SRU to DPRU
                dpru_ram[dpru_addr] <= sru_reg[SRU_DEPTH-1];
                dpru_addr <= dpru_addr + 1;
                ctrl_state <= 2'b00;
            end
            2'b10: begin // POP
                // Pop data from DPRU to SRU
                dataOut <= dpru_ram[dpru_addr-1];
                dpru_ram[dpru_addr-1] <= {DATA_WIDTH{1'b0}};
                dpru_addr <= dpru_addr - 1;
                ctrl_state <= 2'b00;
            end
            default: begin
                ctrl_state <= 2'b00;
            end
        endcase
    end
end

endmodule