module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define the states as an enumerated type
enum {STATE_A, STATE_B} state, next_state;

// Define a 2-bit counter to track the window
reg [1:0] window_counter;
reg [1:0] next_window_counter;

// Define a 2-bit signal to track w occurrences
reg [1:0] w_count;
reg [1:0] next_w_count;

// Combinational logic to compute the next state and counter values
always @(*) begin
    next_state = state;
    next_window_counter = window_counter;
    next_w_count = w_count;
    case(state)
        STATE_A: begin
            if(s) begin
                next_state = STATE_B;
                next_window_counter = 2'b00;
                next_w_count = 2'b00;
            end
        end
        STATE_B: begin
            if(window_counter == 2'b10) begin
                next_window_counter = 2'b00;
                if(w_count == 2'b10) begin
                    z = 1'b1; // Set z high if w occurred exactly twice in the previous window
                end else begin
                    z = 1'b0;
                end
            end else begin
                next_window_counter = window_counter + 1'b1;
                if(w) begin
                    next_w_count = w_count + 1'b1;
                end
            end
        end
    endcase
end

// Sequential logic to update the state and counter registers
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        window_counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        state <= next_state;
        window_counter <= next_window_counter;
        w_count <= next_w_count;
    end
end

endmodule