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

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_en;

    // State transition and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Bit counter and shift register
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
                if (shift_en) begin
                    shift_reg <= {in, shift_reg[7:1]}; // LSB first
                end
            end else begin
                bit_count <= 3'b0;
            end
            
            // Done signal (combinational output registered)
            done <= (state == STOP) && (in == 1'b1);
        end
    end

    // Next state and shift enable logic
    always @(*) begin
        next_state = state;
        shift_en = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                    shift_en = 1'b1;
                end
            end
            
            RECEIVE: begin
                shift_en = 1'b1;
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            
            WAIT: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule