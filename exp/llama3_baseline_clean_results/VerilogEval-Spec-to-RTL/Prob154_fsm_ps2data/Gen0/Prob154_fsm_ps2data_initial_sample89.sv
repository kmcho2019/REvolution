module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

// State machine states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// Counter to keep track of the current byte number
logic [1:0] byte_num;

// Register to store the captured bytes
logic [23:0] bytes;

// State machine logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        byte_num <= 2'b00;
        bytes <= 24'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    bytes[7:0] <= in;
                    byte_num <= 2'b01;
                    next_state <= BYTE1;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE1: begin
                bytes[15:8] <= in;
                byte_num <= 2'b10;
                next_state <= BYTE2;
            end
            BYTE2: begin
                bytes[23:16] <= in;
                byte_num <= 2'b11;
                next_state <= BYTE3;
            end
            BYTE3: begin
                next_state <= IDLE;
            end
            default: next_state <= IDLE;
        endcase
    end
end

// Output logic
assign done = (state == BYTE3);
assign out_bytes = bytes;

endmodule