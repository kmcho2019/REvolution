module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output reg dout
);

    reg [1:0] ptr;       // 2-bit binary pointer (0-3)
    reg [3:0] data_reg;  // Data storage register
    wire ptr_last = (ptr == 2'b11);  // Detect last position

    // Next pointer value (binary counter)
    wire [1:0] next_ptr = ptr_last ? 2'b00 : ptr + 1'b1;

    // Combinatorial valid output (asserted when loading new data)
    assign valid_out = ptr_last;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
        end else begin
            ptr <= next_ptr;
            
            // Load new data when pointer wraps
            if (ptr_last) begin
                data_reg <= d;
            end
            
            // Output current bit based on pointer
            case (ptr)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase
        end
    end

endmodule