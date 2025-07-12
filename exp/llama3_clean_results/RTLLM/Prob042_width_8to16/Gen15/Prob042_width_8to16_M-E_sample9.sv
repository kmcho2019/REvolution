module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    FIRST_BYTE_RECEIVED,
    SECOND_BYTE_RECEIVED
} state, next_state;

reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        first_byte <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_byte <= data_in;
                    state <= FIRST_BYTE_RECEIVED;
                end else begin
                    state <= IDLE;
                end
            end
            FIRST_BYTE_RECEIVED: begin
                if (valid_in) begin
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= SECOND_BYTE_RECEIVED;
                end else begin
                    state <= FIRST_BYTE_RECEIVED;
                end
            end
            SECOND_BYTE_RECEIVED: begin
                valid_out <= 1'b0;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule