module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Circular buffer implementation
    reg [3:0] buffer_mem [0:3];
    reg [1:0] write_ptr;  // Points to next write location
    reg [1:0] read_ptr;   // Points to next read location
    reg [1:0] count;      // Tracks number of valid entries
    reg data_valid;       // Output data valid flag

    // Combinational next state signals
    wire [1:0] next_count;
    wire [1:0] next_write_ptr;
    wire [1:0] next_read_ptr;
    wire next_empty, next_full;

    // Pointer arithmetic
    assign next_write_ptr = (write_ptr == 2'd3) ? 2'd0 : write_ptr + 1;
    assign next_read_ptr = (read_ptr == 2'd3) ? 2'd0 : read_ptr + 1;
    
    // Count update logic
    assign next_count = (!RW && EN && !FULL) ? count + 1 :
                       (RW && EN && !EMPTY) ? count - 1 :
                       count;

    // Flag generation
    assign next_empty = (next_count == 2'd0);
    assign next_full = (next_count == 2'd3);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and flags
            write_ptr <= 2'd0;
            read_ptr <= 2'd0;
            count <= 2'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            data_valid <= 1'b0;
            dataOut <= 4'b0;
        end
        else begin
            // Update count and flags
            count <= next_count;
            EMPTY <= next_empty;
            FULL <= next_full;

            // Handle operations
            if (EN) begin
                if (!RW && !FULL) begin
                    // Write operation
                    buffer_mem[write_ptr] <= dataIn;
                    write_ptr <= next_write_ptr;
                    data_valid <= 1'b0;
                end
                else if (RW && !EMPTY) begin
                    // Read operation
                    dataOut <= buffer_mem[read_ptr];
                    read_ptr <= next_read_ptr;
                    data_valid <= 1'b1;
                end
                else begin
                    data_valid <= 1'b0;
                end
            end
            else begin
                data_valid <= 1'b0;
            end
        end
    end

    // Optional: Power gating for unused memory locations
    // (Implementation depends on target technology)
    // generate
    //     genvar i;
    //     for (i = 0; i < 4; i = i + 1) begin : mem_pwr_gate
    //         // Insert technology-specific power gating here
    //     end
    // endgenerate

endmodule