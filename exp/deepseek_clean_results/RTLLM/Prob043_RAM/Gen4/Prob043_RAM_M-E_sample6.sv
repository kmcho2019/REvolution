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
parameter BANKS = 2;

// Banked memory declaration
reg [WIDTH-1:0] bank0 [0:(DEPTH/BANKS)-1];
reg [WIDTH-1:0] bank1 [0:(DEPTH/BANKS)-1];
reg [WIDTH-1:0] last_write_data;
reg [2:0] last_write_addr;
reg last_write_valid;

// Gray coded addresses for power optimization
reg [2:0] write_addr_gray;
reg [2:0] read_addr_gray;

// Pipeline registers
reg [WIDTH-1:0] read_data_pipe;
reg read_valid_pipe;

// FSM for staggered reset
typedef enum {IDLE, RESET_BANK0, RESET_BANK1, DONE} reset_state_t;
reset_state_t reset_state;

// Address conversion to gray code
function [2:0] bin2gray(input [2:0] bin);
    bin2gray = bin ^ (bin >> 1);
endfunction

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reset_state <= IDLE;
        last_write_valid <= 1'b0;
        write_addr_gray <= 3'b0;
    end
    else begin
        write_addr_gray <= bin2gray(write_addr);
        
        case (reset_state)
            IDLE: reset_state <= RESET_BANK0;
            RESET_BANK0: begin
                for (int i = 0; i < DEPTH/BANKS; i++) begin
                    bank0[i] <= {WIDTH{1'b0}};
                end
                reset_state <= RESET_BANK1;
            end
            RESET_BANK1: begin
                for (int i = 0; i < DEPTH/BANKS; i++) begin
                    bank1[i] <= {WIDTH{1'b0}};
                end
                reset_state <= DONE;
            end
            DONE: begin
                if (write_en) begin
                    // Write to appropriate bank
                    if (write_addr[2] == 1'b0) begin
                        bank0[write_addr[1:0]] <= write_data;
                    end
                    else begin
                        bank1[write_addr[1:0]] <= write_data;
                    end
                    // Cache last write
                    last_write_data <= write_data;
                    last_write_addr <= write_addr;
                    last_write_valid <= 1'b1;
                end
            end
        endcase
    end
end

// Read operation with 1-stage pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_pipe <= {WIDTH{1'b0}};
        read_valid_pipe <= 1'b0;
        read_addr_gray <= 3'b0;
    end
    else begin
        read_addr_gray <= bin2gray(read_addr);
        
        // Pipeline stage 1
        read_valid_pipe <= read_en;
        
        if (read_en) begin
            // Check for read-after-write hazard
            if (last_write_valid && (read_addr == last_write_addr)) begin
                read_data_pipe <= last_write_data;
            end
            else begin
                // Read from appropriate bank
                if (read_addr[2] == 1'b0) begin
                    read_data_pipe <= bank0[read_addr[1:0]];
                end
                else begin
                    read_data_pipe <= bank1[read_addr[1:0]];
                end
            end
        end
        else begin
            read_data_pipe <= {WIDTH{1'b0}};
        end
    end
end

// Pipeline stage 2 (output)
always @(*) begin
    read_data = read_valid_pipe ? read_data_pipe : {WIDTH{1'b0}};
end

endmodule