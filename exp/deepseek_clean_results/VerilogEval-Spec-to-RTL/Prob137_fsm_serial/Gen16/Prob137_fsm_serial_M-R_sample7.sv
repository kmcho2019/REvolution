module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary encoded states
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;
    
    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Continuous assignment for done signal
    assign done = (state == STOP_WAIT) && (in == 1'b1);

    // Combined state and data logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP_WAIT;
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule