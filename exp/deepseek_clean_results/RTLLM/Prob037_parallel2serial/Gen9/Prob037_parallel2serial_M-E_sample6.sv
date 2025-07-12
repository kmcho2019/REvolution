module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_reg;     // Circular buffer storage
    reg [1:0] ptr;          // Pointer to current bit
    wire load;              // Signal to load new data
    
    // Pointer wraps around after 3
    assign load = (ptr == 2'd3);
    
    // Next pointer value
    wire [1:0] next_ptr = load ? 2'd0 : ptr + 1'd1;
    
    // Output selection mux
    always @(*) begin
        case (ptr)
            2'd0: dout = data_reg[3];
            2'd1: dout = data_reg[2];
            2'd2: dout = data_reg[1];
            2'd3: dout = data_reg[0];
        endcase
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'd0;
            data_reg <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            // Update pointer
            ptr <= next_ptr;
            
            // Load new data when pointer wraps
            if (load) begin
                data_reg <= d;
            end
            
            // Generate valid_out one cycle early
            valid_out <= (next_ptr == 2'd0);
        end
    end

endmodule