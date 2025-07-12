module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary encoded states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam WAIT    = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] bit_count;
    reg [7:0] data_reg;
    wire shift_en = (state == RECEIVE) || (state == IDLE && in == 1'b0);

    // Continuous assignment for shift register
    always @(posedge clk) begin
        if (shift_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 2'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 2'b0;
            end
            
            // Done signal (registered)
            done <= (state == RECEIVE && bit_count == 2'b11 && in == 1'b1);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 2'b11) begin
                    next_state = (in == 1'b1) ? IDLE : WAIT;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            WAIT: begin
                next_state = (in == 1'b1) ? IDLE : WAIT;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule