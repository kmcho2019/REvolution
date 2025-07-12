module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

// Enum for states
enum logic [1:0] {IDLE, WAIT_FOR_SECOND} state, next_state;

// Register to hold the first 8-bit data
reg [7:0] first_data;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        first_data <= 8'd0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_data <= data_in;
                    next_state <= WAIT_FOR_SECOND;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            WAIT_FOR_SECOND: begin
                if (valid_in) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= WAIT_FOR_SECOND;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

// Output logic
assign valid_out = (state == WAIT_FOR_SECOND) && valid_in;
assign data_out = {first_data, data_in};

endmodule