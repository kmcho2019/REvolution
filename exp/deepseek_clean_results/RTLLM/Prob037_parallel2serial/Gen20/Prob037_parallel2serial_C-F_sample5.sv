module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] state_gray;   // Gray code state (00,01,11,10)
    reg [3:0] data_reg;     // Data storage register
    
    // Gray code state transitions
    wire [1:0] next_state = (state_gray == 2'b10) ? 2'b00 : 
                          (state_gray == 2'b00) ? 2'b01 :
                          (state_gray == 2'b01) ? 2'b11 : 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_gray <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            state_gray <= next_state;
            
            // Load new data at last state
            if (state_gray == 2'b10) begin
                data_reg <= d;
                dout <= d[3];  // Output MSB first
            end
            else begin
                // Output next bit without full shift to save power
                case(state_gray)
                    2'b00: dout <= data_reg[3];
                    2'b01: dout <= data_reg[2];
                    2'b11: dout <= data_reg[1];
                    2'b10: dout <= data_reg[0];
                endcase
            end
            
            // Valid when first bit is being output
            valid_out <= (next_state == 2'b00);
        end
    end

endmodule