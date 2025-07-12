module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default value
            
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in == 1) begin
                        state <= IDLE;
                        done <= 1'b1;
                    end else begin
                        state <= WAIT;
                    end
                end
                
                WAIT: begin
                    if (in == 1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule