module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // Binary encoded states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg shift_en;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            if (shift_en) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
                bit_count <= bit_count + 1;
            end else if (state == IDLE) begin
                bit_count <= 3'b0;
            end
        end
    end

    // Combinational next state and control logic
    always @(*) begin
        next_state = state;
        shift_en = 1'b0;
        
        case (state)
            IDLE: begin
                if (~in) begin
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
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            
            ERROR: begin
                if (in) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Done is high when we successfully receive a stop bit
    assign done = (state == STOP) && in;

endmodule