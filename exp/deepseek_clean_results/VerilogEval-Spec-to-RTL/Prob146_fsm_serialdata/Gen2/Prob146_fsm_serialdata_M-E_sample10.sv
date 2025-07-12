module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Gray-coded states for optimal transitions
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b11;
    
    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg data_valid;
    
    // Clock gating control
    wire output_clk_en = (state == STOP) && in;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            data_reg <= 8'b0;
            data_valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_valid <= 1'b0;
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b111;
                    end
                end
                
                RECEIVE: begin
                    // Parallel capture of bits into their positions
                    data_reg[bit_count] <= in;
                    
                    if (bit_count == 3'b000) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        data_valid <= 1'b1;
                        state <= IDLE;
                    end else begin  // Missing stop bit
                        // Stay in STOP state until we see stop bit
                        data_valid <= 1'b0;
                    end
                end
            endcase
        end
    end
    
    // Output registers with clock gating
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
            done <= 1'b0;
        end else if (output_clk_en) begin
            out_byte <= data_reg;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule