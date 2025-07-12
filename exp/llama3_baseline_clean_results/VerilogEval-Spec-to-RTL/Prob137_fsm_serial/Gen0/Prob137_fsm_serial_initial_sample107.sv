module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    RECEIVE_DATA,
    STOP_BIT,
    DONE_STATE
} state, next_state;

// Counter to keep track of the number of data bits received
logic [2:0] data_count;

// Output signal to indicate when a byte is correctly received
assign done = (state == DONE_STATE);

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (~in) begin
                    next_state <= RECEIVE_DATA;
                    data_count <= 0;
                end else begin
                    next_state <= IDLE;
                end
            end
            RECEIVE_DATA: begin
                data_count <= data_count + 1;
                if (data_count == 7) begin
                    next_state <= STOP_BIT;
                end else begin
                    next_state <= RECEIVE_DATA;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= IDLE;
                end
            end
            DONE_STATE: begin
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule