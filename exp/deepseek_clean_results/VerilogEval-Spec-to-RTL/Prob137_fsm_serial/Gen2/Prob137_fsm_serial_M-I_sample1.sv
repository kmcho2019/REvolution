module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    
    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;  // Default to 0
            
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected (active low)
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first reception
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit (active high)
                        state <= IDLE;
                        done_reg <= 1'b1;
                    end
                    // Stay in STOP until we get valid stop bit
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    assign done = done_reg;

endmodule