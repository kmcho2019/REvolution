module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // Define states
    localparam IDLE  = 3'b000;
    localparam START = 3'b001;
    localparam DATA  = 3'b010;
    localparam STOP  = 3'b011;
    localparam ERROR = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            // Bit counter logic
            if (state == DATA) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Done signal logic (pulse when valid byte received)
            if (state == STOP && in) begin
                done_reg <= 1'b1;
            end else begin
                done_reg <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                next_state = (bit_count == 3'b111) ? STOP : DATA;
            end
            STOP: begin
                next_state = in ? IDLE : STOP;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule