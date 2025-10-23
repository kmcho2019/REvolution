module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE        = 2'b00;
    localparam RECEIVE     = 2'b01;
    localparam WAIT_STOP   = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg done_reg;
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 1'b0;
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                        data_shift <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // LSB first
                    if (bit_count == 3'b111) begin
                        state <= WAIT_STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                
                WAIT_STOP: begin
                    if (in) begin  // Stop bit detected
                        state <= IDLE;
                        done_reg <= 1'b1;
                    end
                    // Otherwise stay in WAIT_STOP until stop bit arrives
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule