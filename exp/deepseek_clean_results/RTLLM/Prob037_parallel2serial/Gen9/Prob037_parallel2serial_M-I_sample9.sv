module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] ptr;       // 2-bit pointer (0-3)
    reg [3:0] data_reg;  // Data storage register
    reg load_flag;       // Flag to indicate load cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b0;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
            load_flag <= 1'b0;
        end else begin
            // Update pointer and load flag
            if (ptr == 2'b11) begin
                ptr <= 2'b0;
                load_flag <= 1'b1;
            end else begin
                ptr <= ptr + 1'b1;
                load_flag <= 1'b0;
            end

            // Load new data when needed
            if (load_flag) begin
                data_reg <= d;
            end

            // Output current bit based on pointer
            case (ptr)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase

            // Valid output one cycle early to match data timing
            valid_out <= (ptr == 2'b11);
        end
    end

endmodule