module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    reg [1:0] state;
    reg [23:0] message_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            message_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= BYTE1;
                        message_reg <= {16'b0, in};
                    end
                end
                
                BYTE1: begin
                    message_reg <= {message_reg[15:0], in};
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    message_reg <= {message_reg[15:0], in};
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    message_reg <= {message_reg[15:0], in};
                    done <= 1'b1;
                    // Check if next byte starts new message
                    if (in[3]) begin
                        state <= BYTE1;
                        message_reg <= {16'b0, in};
                    end else begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule