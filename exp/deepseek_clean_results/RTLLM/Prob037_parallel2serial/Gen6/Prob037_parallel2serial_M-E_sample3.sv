module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_buffer;      // Circular buffer storage
    reg [1:0] read_ptr;         // Binary read pointer (0-3)
    reg [1:0] write_ptr;        // Binary write pointer (0-3)
    reg load_pending;           // Flag indicating new data to load
    
    // Next state computation
    wire [1:0] next_read_ptr = (read_ptr == 2'b11) ? 2'b00 : (read_ptr + 1'b1);
    wire buffer_empty = (read_ptr == write_ptr) && !load_pending;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_ptr <= 2'b00;
            write_ptr <= 2'b00;
            data_buffer <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
            load_pending <= 1'b0;
        end else begin
            // Default assignments
            valid_out <= 1'b0;
            
            // Data output and pointer update
            if (!buffer_empty) begin
                dout <= data_buffer[3-read_ptr];  // MSB-first output
                read_ptr <= next_read_ptr;
                valid_out <= 1'b1;
                
                // Predictive valid for next cycle
                if (next_read_ptr != write_ptr || load_pending) begin
                    valid_out <= 1'b1;
                end
            end
            
            // Parallel load handling
            if (read_ptr == 2'b00 && !buffer_empty) begin
                load_pending <= 1'b0;
            end
            
            if (read_ptr == write_ptr) begin
                data_buffer <= d;
                write_ptr <= next_read_ptr;
                load_pending <= 1'b1;
            end
        end
    end

endmodule