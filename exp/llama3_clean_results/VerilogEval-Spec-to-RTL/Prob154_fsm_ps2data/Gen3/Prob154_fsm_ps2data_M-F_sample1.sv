module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// State declaration
enum logic [1:0] {IDLE, BYTE1, BYTE2} state;

// Internal registers to store the bytes
logic [7:0] byte1, byte2, byte3;

// Sequential logic to update the state and internal registers
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
        done <= 1'b0;
        out_bytes <= 24'd0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= BYTE1;
                    byte1 <= in;
                end
            end
            BYTE1: begin
                state <= BYTE2;
                byte2 <= in;
            end
            BYTE2: begin
                state <= IDLE;
                byte3 <= in;
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3};
            end
            default: state <= IDLE;
        endcase
        if (state != BYTE2) begin
            done <= 1'b0;
        end
    end
end

endmodule