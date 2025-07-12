module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// Define registers to hold bytes
logic [7:0] byte1, byte2, byte3;

// FSM logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
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
    endcase
end

// Datapath logic
always_comb begin
    case (state)
        IDLE: begin
            out_bytes = 24'b0;
            done = 1'b0;
        end
        BYTE1: begin
            out_bytes = {in, 16'b0};
            done = 1'b0;
        end
        BYTE2: begin
            out_bytes = {byte1, in, 8'b0};
            done = 1'b0;
        end
        BYTE3: begin
            out_bytes = {byte1, byte2, in};
            done = 1'b1;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                end
            end
            BYTE1: begin
                byte2 <= in;
            end
            BYTE2: begin
                byte3 <= in;
            end
            default: begin
                // No action needed
            end
        endcase
    end
end

endmodule