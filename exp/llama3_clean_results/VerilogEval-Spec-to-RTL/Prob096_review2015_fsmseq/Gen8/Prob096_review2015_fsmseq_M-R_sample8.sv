module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
enum logic [1:0] {
    IDLE,
    DETECTED
} state, next_state;

// Define the shift register
reg [3:0] shift_register;

// Combinational logic to update the next state
always_comb begin
    case (state)
        IDLE: begin
            if (shift_register == 4'b1101) begin
                next_state = DETECTED;
            end else begin
                next_state = IDLE;
            end
        end
        DETECTED: begin
            next_state = DETECTED;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic to update the state and shift register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_register <= 4'b0000;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        shift_register <= {data, shift_register[3:1]};
        case (state)
            IDLE: begin
                start_shifting <= 1'b0;
            end
            DETECTED: begin
                start_shifting <= 1'b1;
            end
            default: begin
                start_shifting <= 1'b0;
            end
        endcase
    end
end

endmodule