module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

// State definitions
enum logic [1:0] {
    IDLE = 2'b00,
    BYTE1 = 2'b01,
    BYTE2 = 2'b10,
    DONE = 2'b11
} state, next_state;

// Registers to store bytes
logic [7:0] byte1, byte2, byte3;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 <= in;
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                byte3 <= in;
                state <= DONE;
            end
            DONE: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Combinational logic
always_comb begin
    case (state)
        IDLE: begin
            out_bytes = 24'b0;
            done = 1'b0;
        end
        BYTE1: begin
            out_bytes = 24'b0;
            done = 1'b0;
        end
        BYTE2: begin
            out_bytes = 24'b0;
            done = 1'b0;
        end
        DONE: begin
            out_bytes = {byte1, byte2, byte3};
            done = 1'b1;
        end
        default: begin
            out_bytes = 24'b0;
            done = 1'b0;
        end
    endcase
end

endmodule