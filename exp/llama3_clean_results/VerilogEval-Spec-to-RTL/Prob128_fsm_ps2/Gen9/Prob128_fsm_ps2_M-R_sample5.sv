module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states
enum logic [1:0] {
    IDLE,
    BYTE_1,
    BYTE_2,
    BYTE_3
} state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE_1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE_1: next_state = BYTE_2;
        BYTE_2: next_state = BYTE_3;
        BYTE_3: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Done signal generation
logic done_reg;
always_ff @(posedge clk) begin
    if (reset) begin
        done_reg <= 1'b0;
    end else if (state == BYTE_3) begin
        done_reg <= 1'b1;
    end else begin
        done_reg <= 1'b0;
    end
end
assign done = done_reg;

endmodule