module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

// Define states for the FSM
enum logic [1:0] {IDLE, WAIT_FOR_SECOND, OUTPUT} state, next_state;

reg [7:0] data_first; // Register to store the first 8-bit data input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= IDLE;
        data_first  <= 8'd0;
    end
    else begin
        state       <= next_state;
        if (next_state == OUTPUT) begin
            // In the OUTPUT state, do not update data_first
        end
        else if (valid_in) begin
            if (state == IDLE) begin
                // Store the first data when moving from IDLE to WAIT_FOR_SECOND
                data_first  <= data_in;
            end
        end
    end
end

always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = WAIT_FOR_SECOND;
            end
        end
        WAIT_FOR_SECOND: begin
            if (valid_in) begin
                next_state = OUTPUT;
            end
            else begin
                // Stay in WAIT_FOR_SECOND if no new data arrives
            end
        end
        OUTPUT: begin
            // After outputting the data, return to IDLE
            next_state = IDLE;
        end
    endcase
end

assign valid_out = (state == OUTPUT);
assign data_out  = (state == OUTPUT) ? {data_first, data_in} : 16'd0;

endmodule