module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Circular buffer with 4 positions (2-bit pointers)
    reg [3:0] data_buffer [0:3];
    reg [1:0] write_ptr;
    reg [1:0] read_ptr;
    reg [1:0] bit_counter;
    
    // Predictive loading indicator
    wire loading_new_data = (bit_counter == 2'd3);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 2'd0;
            read_ptr <= 2'd1;  // Offset by 1 position
            bit_counter <= 2'd0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            // Initialize buffer (not strictly necessary)
            data_buffer[0] <= 4'b0;
            data_buffer[1] <= 4'b0;
            data_buffer[2] <= 4'b0;
            data_buffer[3] <= 4'b0;
        end else begin
            // Always store incoming data (may be overwritten if not used)
            data_buffer[write_ptr] <= d;
            
            // Update pointers and counters
            bit_counter <= bit_counter + 1'b1;
            
            if (loading_new_data) begin
                write_ptr <= write_ptr + 1'b1;
                valid_out <= 1'b1;  // Signal valid data starting next cycle
            end
            
            // Read pointer follows write pointer with 4-cycle delay
            if (bit_counter == 2'd2) begin
                read_ptr <= write_ptr;
            end
            
            // Output selection
            case (bit_counter)
                2'd0: dout <= data_buffer[read_ptr][3];
                2'd1: dout <= data_buffer[read_ptr][2];
                2'd2: dout <= data_buffer[read_ptr][1];
                2'd3: dout <= data_buffer[read_ptr][0];
            endcase
        end
    end
endmodule