module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    
    // Continuous assignment for done signal
    assign done = (state == STOP) && in;
    
    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) state <= RECEIVE;
                end
                
                RECEIVE: begin
                    if (bit_count == 3'b0) state <= STOP;
                end
                
                STOP: begin
                    if (in) state <= IDLE;
                    // Stay in STOP until stop bit found
                end
            endcase
        end
    end
    
    // Data path
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b111;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'b111;
                    shift_reg <= 8'b0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count - 1;
                end
                
                STOP: begin
                    if (in) out_byte <= shift_reg;
                end
            endcase
        end
    end

endmodule