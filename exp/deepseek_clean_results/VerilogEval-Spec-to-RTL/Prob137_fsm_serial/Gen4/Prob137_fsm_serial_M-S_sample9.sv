module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE     = 1'b0;
    localparam RECEIVING = 1'b1;

    reg state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RECEIVING;
                        bit_count <= 3'b0;
                    end
                end
                
                RECEIVING: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift right, LSB first
                    if (bit_count == 3'b111) begin
                        state <= IDLE;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
            endcase
        end
    end

    // Stop bit verification and done signal
    assign done = (state == RECEIVING && bit_count == 3'b111 && in == 1'b1);

endmodule