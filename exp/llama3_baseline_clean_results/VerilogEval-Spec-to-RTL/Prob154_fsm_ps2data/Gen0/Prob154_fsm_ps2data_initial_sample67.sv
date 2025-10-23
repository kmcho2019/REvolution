module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// Define the registers to hold the bytes
logic [7:0] byte1, byte2, byte3;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 <= in;
                end
            end
            BYTE1: begin
                byte2 <= in;
            end
            BYTE2: begin
                byte3 <= in;
            end
            default: ;
        endcase
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = IDLE;
        end
        default: ;
    endcase
end

// Output logic
assign done = (state == BYTE3);
assign out_bytes = {byte1, byte2, byte3};

endmodule