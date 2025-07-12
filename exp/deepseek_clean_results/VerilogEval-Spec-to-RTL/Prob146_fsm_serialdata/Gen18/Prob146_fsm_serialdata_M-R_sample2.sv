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

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Continuous assignments for next state logic
    wire start_bit = (in == 1'b0);
    wire all_bits_received = (bit_count == 3'b111);
    wire valid_stop = (in == 1'b1);

    wire next_IDLE = (state == IDLE && !start_bit) || 
                    (state == STOP && valid_stop);
    wire next_RECEIVE = (state == IDLE && start_bit) ||
                       (state == RECEIVE && !all_bits_received);
    wire next_STOP = (state == RECEIVE && all_bits_received) ||
                    (state == STOP && !valid_stop);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;  // Default to 0 (one-cycle pulse)
            
            case (1'b1)  // Synthesis will optimize this case statement
                next_IDLE: begin
                    state <= IDLE;
                    bit_count <= 3'b0;
                end
                
                next_RECEIVE: begin
                    state <= RECEIVE;
                    shift_reg <= {shift_reg[6:0], in};  // Left shift
                    bit_count <= bit_count + 1;
                end
                
                next_STOP: begin
                    state <= STOP;
                    if (valid_stop) begin
                        out_byte <= shift_reg;
                        done_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule