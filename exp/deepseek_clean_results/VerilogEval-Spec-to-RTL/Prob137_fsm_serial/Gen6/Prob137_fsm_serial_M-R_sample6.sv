module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE     = 4'b0001;
    localparam RECEIVING = 4'b0010;
    localparam STOP     = 4'b0100;
    localparam ERROR    = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;

    // Combined state transition and data handling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;  // Down counter starting at 7
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 1'b0;
                    if (!in) begin  // Start bit detected
                        state <= RECEIVING;
                        bit_count <= 3'b111;  // Reset counter
                    end
                end
                
                RECEIVING: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift right
                    if (bit_count == 3'b0) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    done_reg <= in;  // Assert done only if stop bit is 1
                    state <= in ? IDLE : ERROR;
                end
                
                ERROR: begin
                    if (in) state <= IDLE;  // Wait for stop bit
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    assign done = done_reg;

endmodule