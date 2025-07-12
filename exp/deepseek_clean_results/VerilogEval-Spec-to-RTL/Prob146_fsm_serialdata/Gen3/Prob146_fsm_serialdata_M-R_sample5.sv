module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam VALIDATE = 2'b10;

    reg [1:0] state;
    reg [7:0] data_reg;
    reg [3:0] bit_count;
    reg stop_bit;

    // Output assignments
    assign out_byte = data_reg;
    assign done = (state == VALIDATE) & stop_bit;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            bit_count <= 0;
            stop_bit <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVING;
                        bit_count <= 0;
                    end
                end
                
                RECEIVING: begin
                    if (bit_count < 8) begin
                        // Shift in data bits (LSB first)
                        data_reg <= {in, data_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end else begin
                        // Capture stop bit
                        stop_bit <= in;
                        state <= VALIDATE;
                    end
                end
                
                VALIDATE: begin
                    // Return to idle after validation
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule