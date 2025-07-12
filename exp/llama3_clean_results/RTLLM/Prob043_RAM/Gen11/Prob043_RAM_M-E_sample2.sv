module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

// Dual RAM arrays
reg [5:0] read_RAM [7:0];
reg [5:0] write_RAM [7:0];

// Shared control logic
reg read_enable;
reg write_enable;

// Arbitration logic
reg arb_read;
reg arb_write;

// Control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_enable <= 1'b0;
        write_enable <= 1'b0;
        arb_read <= 1'b0;
        arb_write <= 1'b0;
    end else begin
        // Read operation
        if (read_en) begin
            read_enable <= 1'b1;
            arb_read <= 1'b1;
        end else begin
            read_enable <= 1'b0;
            arb_read <= 1'b0;
        end

        // Write operation
        if (write_en) begin
            write_enable <= 1'b1;
            arb_write <= 1'b1;
        end else begin
            write_enable <= 1'b0;
            arb_write <= 1'b0;
        end
    end
end

// Read operation
always @(posedge clk) begin
    if (read_enable && arb_read) begin
        read_data <= read_RAM[read_addr];
    end else begin
        read_data <= 6'b0;
    end
end

// Write operation
always @(posedge clk) begin
    if (write_enable && arb_write) begin
        write_RAM[write_addr] <= write_data;
    end
end

// Update read RAM
always @(posedge clk) begin
    for (int i = 0; i < DEPTH; i++) begin
        read_RAM[i] <= write_RAM[i];
    end
end

endmodule