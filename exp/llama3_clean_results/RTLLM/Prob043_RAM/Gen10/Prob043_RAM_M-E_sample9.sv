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

// RAM array
reg [5:0] RAM [7:0];

// Pipeline stage registers for read operation
reg [2:0] read_addr_pipe;
reg [5:0] read_data_pipe;

// Write-through cache
reg [5:0] cache_data;
reg [2:0] cache_addr;
reg cache_valid;

// Dynamic clock gating control
reg clk_gated;
reg [1:0] idle_counter;

// State machine for pipeline and cache management
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers and state
        read_addr_pipe <= 3'b0;
        read_data_pipe <= 6'b0;
        cache_data <= 6'b0;
        cache_addr <= 3'b0;
        cache_valid <= 1'b0;
        clk_gated <= 1'b0;
        idle_counter <= 2'b0;
        state <= 2'b0;
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else begin
        // Manage clock gating
        if (write_en || read_en) begin
            clk_gated <= 1'b1;
            idle_counter <= 2'b0;
        end else if (idle_counter == 2'b11) begin
            clk_gated <= 1'b0;
        end else begin
            idle_counter <= idle_counter + 1'b1;
        end

        // Pipeline read operation
        case (state)
            2'b00: begin
                if (read_en) begin
                    read_addr_pipe <= read_addr;
                    state <= 2'b01;
                end
            end
            2'b01: begin
                read_data_pipe <= RAM[read_addr_pipe];
                state <= 2'b10;
            end
            2'b10: begin
                read_data <= read_data_pipe;
                state <= 2'b00;
            end
        endcase

        // Write operation
        if (write_en) begin
            RAM[write_addr] <= write_data;
            cache_data <= write_data;
            cache_addr <= write_addr;
            cache_valid <= 1'b1;
        end

        // Cache management
        if (cache_valid && (cache_addr == read_addr_pipe)) begin
            read_data_pipe <= cache_data;
        end
    end
end

endmodule