module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states as enumeration values
enum logic [1:0] {
    IDLE,
    FLAG,
    ERR,
    DISCARD
} state, next_state;

// Shift register to track the last few bits
logic [6:0] shift_reg;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 7'b0;
    end else begin
        state <= next_state;
        shift_reg <= {shift_reg[5:0], in};
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (shift_reg == 7'b01111110) begin
                next_state = FLAG;
            end else if (shift_reg == 7'b0111111) begin
                next_state = DISCARD;
            end else if (shift_reg == 7'b1111111) begin
                next_state = ERR;
            end else begin
                next_state = IDLE;
            end
        end
        FLAG: begin
            next_state = IDLE;
        end
        ERR: begin
            if (~in) begin
                next_state = IDLE;
            end else begin
                next_state = ERR;
            end
        end
        DISCARD: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
always_comb begin
    case (state)
        IDLE: begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end
        FLAG: begin
            disc <= 1'b0;
            flag <= 1'b1;
            err <= 1'b0;
        end
        ERR: begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b1;
        end
        DISCARD: begin
            disc <= 1'b1;
            flag <= 1'b0;
            err <= 1'b0;
        end
        default: begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end
    endcase
end

endmodule