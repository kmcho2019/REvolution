module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] state;  // Binary state (0-3)
    reg [3:0] data_reg;

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Update state
            state <= (state == 2'b11) ? 2'b00 : state + 1;
            
            // Load new data when state wraps around
            if (state == 2'b11) begin
                data_reg <= d;
            end
            
            // Generate valid_out
            valid_out <= (state == 2'b00);
            
            // Serial output selection
            case (state)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase
        end
    end

endmodule