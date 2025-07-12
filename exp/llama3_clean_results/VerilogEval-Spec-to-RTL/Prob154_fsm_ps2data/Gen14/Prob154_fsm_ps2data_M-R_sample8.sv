module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define enumerated type for states
typedef enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2
} state_t;

// Declare state register
reg [1:0] state;

// Declare next state register
reg [1:0] next_state;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
                done <= 1'b0;
            end
            BYTE1: begin
                out_bytes[15:8] <= in;
                state <= BYTE2;
                done <= 1'b0;
            end
            BYTE2: begin
                out_bytes[7:0] <= in;
                state <= IDLE;
                done <= 1'b1;
            end
            default: begin
                state <= IDLE;
                done <= 1'b0;
            end
        endcase
    end
end

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = (in[3] == 1'b1) ? BYTE1 : IDLE;
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Assign output signals
assign done = (state == BYTE2) ? 1'b1 : 1'b0;

endmodule