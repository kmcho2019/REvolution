module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states - binary encoding for area efficiency
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, state_reg;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg next_done;

    // Registered state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            state_reg <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state_reg <= state;
            state <= next_state;
            
            // Only update shift register when in RECEIVE state
            if (state == RECEIVE) begin
                shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                bit_count <= bit_count + 1;
            end else if (state == IDLE) begin
                bit_count <= 3'b0;
            end

            // Output and done pulse generation
            if (state_reg == STOP && in) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = (in == 1'b1) ? IDLE : STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule