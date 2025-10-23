module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

// Define the states of the FSM
enum logic [1:0] {WAIT_FOR_FIRST_DATA, WAIT_FOR_SECOND_DATA, OUTPUT_DATA} state, next_state;

// Register to store the first 8-bit data input
reg [7:0] data_buffer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= WAIT_FOR_FIRST_DATA;
        data_buffer   <= 8'd0;
        valid_out     <= 1'b0;
        data_out      <= 16'd0;
    end
    else begin
        case (state)
            WAIT_FOR_FIRST_DATA: begin
                if (valid_in) begin
                    data_buffer   <= data_in;
                    state         <= WAIT_FOR_SECOND_DATA;
                end
            end
            WAIT_FOR_SECOND_DATA: begin
                if (valid_in) begin
                    data_out      <= {data_buffer, data_in};
                    valid_out     <= 1'b1;
                    state         <= OUTPUT_DATA;
                end
            end
            OUTPUT_DATA: begin
                valid_out     <= 1'b0;
                state         <= WAIT_FOR_FIRST_DATA;
            end
            default: begin
                state         <= WAIT_FOR_FIRST_DATA;
            end
        endcase
    end
end

endmodule