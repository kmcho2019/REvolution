module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_reg;
    reg [1:0] ptr;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            ptr <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Pointer increment with wrap-around
            if (ptr == 2'b11) begin
                ptr <= 2'b00;
                data_reg <= d;       // Load new parallel data
                valid_out <= 1'b1;   // Valid when new data loaded
            end else begin
                ptr <= ptr + 1'b1;
                valid_out <= 1'b0;
            end
            
            // Bit selection based on pointer
            case (ptr)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
                default: dout <= 1'b0;
            endcase
        end
    end

endmodule