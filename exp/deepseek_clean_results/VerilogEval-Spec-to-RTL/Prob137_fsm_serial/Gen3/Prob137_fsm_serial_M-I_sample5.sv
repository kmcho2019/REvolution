module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // One-hot encoded states
    localparam IDLE  = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP = 4'b0100;
    localparam WAIT = 4'b1000;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // Clock gating for shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (shift_enable) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Done signal generation (pipelined)
            done <= (state == STOP) && (in == 1'b1);
        end
    end

    // Next state and control logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                shift_enable = 1'b1;
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