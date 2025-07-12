module DualPortRAM (
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

// RAM Array
reg [5:0] RAM [7:0];

// Arbitration Logic
reg arb_read, arb_write;
reg [1:0] arb_state; // 0: idle, 1: read, 2: write
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        arb_state <= 0;
    end else begin
        case (arb_state)
            0: begin
                if (read_en && write_en) begin
                    // Both operations requested, start with read
                    arb_state <= 1;
                end else if (read_en) begin
                    arb_state <= 1;
                end else if (write_en) begin
                    arb_state <= 2;
                end
            end
            1: begin
                // Read operation in progress
                if (!read_en) begin
                    arb_state <= 2;
                end
            end
            2: begin
                // Write operation in progress
                if (!write_en) begin
                    arb_state <= 0;
                end
            end
        endcase
    end
end

// Read Controller
always @(posedge clk) begin
    if (arb_state == 1) begin
        read_data <= RAM[read_addr];
    end else begin
        read_data <= 6'b0;
    end
end

// Write Controller
always @(posedge clk) begin
    if (arb_state == 2) begin
        RAM[write_addr] <= write_data;
    end
end

// Reset Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
        read_data <= 6'b0;
    end
end

endmodule