module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary encoded states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg shift_en;
    reg done_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Data shift logic with clock gating
            if (shift_en) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
            end
            
            // Optimized done signal - pulses only at valid stop bits
            done_reg <= (state == STOP) && in && (next_state == IDLE);
        end
    end

    // Combinational next state and control logic
    always @(*) begin
        next_state = state;
        shift_en = 1'b0;
        
        case (state)
            IDLE: begin
                if (!in) begin
                    next_state = RECEIVE;
                    shift_en = 1'b1;
                end
            end
            
            RECEIVE: begin
                shift_en = 1'b1;
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            
            WAIT: begin
                if (in) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign done = done_reg;

endmodule