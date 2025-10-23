module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// State declaration
enum logic [1:0] {IDLE, RECEIVING_1, RECEIVING_2, RECEIVING_3} state;

// Registers to store the incoming bytes
reg [7:0] byte1, byte2, byte3;

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
                    state <= RECEIVING_1;
                    byte1 <= in;
                end
            end
            RECEIVING_1: begin
                state <= RECEIVING_2;
                byte2 <= in;
            end
            RECEIVING_2: begin
                state <= RECEIVING_3;
                byte3 <= in;
            end
            RECEIVING_3: begin
                state <= IDLE;
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3};
            end
            default: state <= IDLE;
        endcase
        if (state!= RECEIVING_3) begin
            done <= 1'b0;
        end
    end
end

endmodule