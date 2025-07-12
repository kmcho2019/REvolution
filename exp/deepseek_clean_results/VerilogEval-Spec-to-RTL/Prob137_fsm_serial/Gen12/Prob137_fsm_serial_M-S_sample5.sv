module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 1'b0;
    localparam ACTIVE  = 1'b1;

    reg state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                end
                
                ACTIVE: begin
                    if (bit_count < 3'b111) begin
                        data_reg <= {in, data_reg[7:1]};  // LSB first
                        bit_count <= bit_count + 1;
                    end
                    else if (in) begin  // Stop bit check
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? ACTIVE : IDLE;
            end
            
            ACTIVE: begin
                next_state = (bit_count == 3'b111 && in == 1'b1) ? IDLE : ACTIVE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule