module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding (binary for minimal area)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;
    reg done_reg;

    // Clock-gated shift register (power optimization)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (shift_enable) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // State and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;  // Default to 0
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Done signal (asserted only when valid stop bit)
            if (state == STOP && in) begin
                done_reg <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;
            end
            
            RECEIVE: begin
                shift_enable = 1'b1;
                if (bit_count == 3'b111) next_state = STOP;
            end
            
            STOP: begin
                if (in) next_state = IDLE;
                else next_state = WAIT;
            end
            
            WAIT: begin
                if (in) next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule