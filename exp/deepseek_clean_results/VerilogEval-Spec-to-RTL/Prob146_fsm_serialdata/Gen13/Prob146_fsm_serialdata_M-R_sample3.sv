module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;  // Count up to 8 bits
    reg shift_en;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
            
            if (shift_en) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB first
                bit_count <= bit_count + 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
                shift_en = 0;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 8) ? STOP : RECEIVE;
                shift_en = 1;
            end
            
            STOP: begin
                next_state = (in == 1) ? IDLE : STOP;
                shift_en = 0;
            end
            
            default: begin
                next_state = IDLE;
                shift_en = 0;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 0;
        end else if (state == STOP && in == 1) begin
            out_byte <= shift_reg;
        end
    end

    // Combinational done signal
    assign done = (state == STOP && in == 1);

endmodule