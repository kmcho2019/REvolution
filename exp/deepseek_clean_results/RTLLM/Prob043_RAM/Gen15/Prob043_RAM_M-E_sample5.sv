module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Banked memory structure
    reg [WIDTH-1:0] bank0 [0:3];  // Even addresses
    reg [WIDTH-1:0] bank1 [0:3];  // Odd addresses
    
    // Shadow registers for read isolation
    reg [WIDTH-1:0] shadow0 [0:3];
    reg [WIDTH-1:0] shadow1 [0:3];
    
    // Write pipeline registers
    reg [2:0] wr_addr_pipe;
    reg [5:0] wr_data_pipe;
    reg wr_en_pipe;
    
    // Phase control
    wire phase = clk;  // Main phase
    wire nphase = ~clk; // Opposite phase
    
    // Write Pipeline Stage 1
    always @(posedge phase or negedge rst_n) begin
        if (!rst_n) begin
            wr_en_pipe <= 0;
            wr_addr_pipe <= 0;
            wr_data_pipe <= 0;
        end else begin
            wr_en_pipe <= write_en;
            wr_addr_pipe <= write_addr;
            wr_data_pipe <= write_data;
        end
    end
    
    // Write Pipeline Stage 2 (banked write)
    always @(posedge nphase or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i=0; i<4; i=i+1) begin
                bank0[i] <= 0;
                bank1[i] <= 0;
            end
        end else if (wr_en_pipe) begin
            if (!wr_addr_pipe[0]) begin
                bank0[wr_addr_pipe[2:1]] <= wr_data_pipe;
            end else begin
                bank1[wr_addr_pipe[2:1]] <= wr_data_pipe;
            end
        end
    end
    
    // Shadow Register Update (opposite phase)
    always @(posedge phase or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i=0; i<4; i=i+1) begin
                shadow0[i] <= 0;
                shadow1[i] <= 0;
            end
        end else begin
            // Copy banks to shadows
            for (integer i=0; i<4; i=i+1) begin
                shadow0[i] <= bank0[i];
                shadow1[i] <= bank1[i];
            end
        end
    end
    
    // Registered Read Path
    always @(posedge phase or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 0;
        end else if (read_en) begin
            if (!read_addr[0]) begin
                read_data <= shadow0[read_addr[2:1]];
            end else begin
                read_data <= shadow1[read_addr[2:1]];
            end
        end else begin
            read_data <= 0;
        end
    end

endmodule