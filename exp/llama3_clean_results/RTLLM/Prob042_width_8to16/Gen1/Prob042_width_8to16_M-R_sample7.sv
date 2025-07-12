module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// Define states
enum {IDLE, LOCKED} state, next_state;

reg [7:0] data_lock;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
        valid_out <= 0;
        data_lock <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_lock <= data_in;
                    next_state <= LOCKED;
                end else begin
                    next_state <= IDLE;
                end
            end
            LOCKED: begin
                if (valid_in) begin
                    data_out <= {data_lock, data_in};
                    valid_out <= 1;
                    next_state <= IDLE;
                end else begin
                    valid_out <= 0;
                    next_state <= LOCKED;
                end
            end
        endcase
    end
end

// Combinational logic for output
assign valid_out = (state == LOCKED && valid_in)? 1'b1 : 1'b0;

endmodule