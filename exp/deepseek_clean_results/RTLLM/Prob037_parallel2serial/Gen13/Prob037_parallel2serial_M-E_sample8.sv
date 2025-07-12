module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] ptr;          // 2-bit pointer (0-3)
    reg [3:0] data_reg;     // Data storage
    reg load_flag;          // Flag to indicate new data load
    
    // Pointer increment logic
    wire [1:0] next_ptr = (ptr == 2'b11) ? 2'b00 : (ptr + 1'b1);
    
    // Output assignments
    assign dout = data_reg[3-ptr];  // MSB first (ptr 0 = bit 3, ptr 1 = bit 2, etc)
    assign valid_out = load_flag;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b00;
            data_reg <= 4'b0;
            load_flag <= 1'b0;
        end else begin
            load_flag <= 1'b0;
            
            if (ptr == 2'b11) begin
                // Wrap around - load new data
                ptr <= 2'b00;
                data_reg <= d;
                load_flag <= 1'b1;
            end else begin
                // Normal operation - increment pointer
                ptr <= next_ptr;
            end
        end
    end

endmodule