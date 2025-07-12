module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] ptr;       // Bit selection pointer (0-3)
    reg [3:0] data_reg;  // Data storage (no shifting)
    reg load_pending;    // Flag for new data loading

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b11;       // Initialize to trigger first load
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
            load_pending <= 1'b1;
        end else begin
            // Update pointer with wrap-around
            ptr <= ptr + 1;

            // Handle data loading and output selection
            if (ptr == 2'b11) begin
                data_reg <= d;          // Load new data
                load_pending <= 1'b1;   // Set load flag
            end

            // Output current bit based on pointer
            case (ptr)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase

            // Generate valid_out one cycle early (when ptr=2)
            valid_out <= (ptr == 2'b10) & load_pending;
            
            // Clear load flag after first valid output
            if (ptr == 2'b10) begin
                load_pending <= 1'b0;
            end
        end
    end

endmodule