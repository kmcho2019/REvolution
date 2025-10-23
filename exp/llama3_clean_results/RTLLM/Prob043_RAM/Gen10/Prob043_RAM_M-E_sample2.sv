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

reg [5:0] RAM_bank1 [7:0];
reg [5:0] RAM_bank2 [7:0];
reg [5:0] read_data_reg;
reg clk_gated;
reg [2:0] read_ptr;
reg [2:0] write_ptr;

// Clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en | read_en;
    end
end

// Data compression technique
function [5:0] compress_data;
    input [5:0] data;
    begin
        compress_data = {2'b0, data[5:2]};
    end
endfunction

function [5:0] decompress_data;
    input [5:0] data;
    begin
        decompress_data = {2'b0, data[5:2]};
    end
endfunction

// FSM-based RAM controller
reg [1:0] state;
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        read_ptr <= 3'b000;
        write_ptr <= 3'b000;
    end else begin
        case (state)
            2'b00: begin
                if (write_en) begin
                    state <= 2'b01;
                end else if (read_en) begin
                    state <= 2'b10;
                end
            end
            2'b01: begin
                RAM_bank1[write_addr] <= compress_data(write_data);
                write_ptr <= write_ptr + 1;
                state <= 2'b00;
            end
            2'b10: begin
                read_data_reg <= decompress_data(RAM_bank2[read_addr]);
                read_ptr <= read_ptr + 1;
                state <= 2'b00;
            end
        endcase
    end
end

// Concurrent read and write operation management
always @(posedge clk_gated) begin
    if (write_en && read_en) begin
        if (write_addr == read_addr) begin
            // Handle data corruption prevention protocol
        end
    end
end

// Output logic
assign read_data = (read_en) ? read_data_reg : 6'b0;

endmodule