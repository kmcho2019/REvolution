module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

// State variable
reg [1:0] state; // 2 states: A (00), B (01, 10, 11 used for counting within B)
reg [1:0] state_next;

// Counter for w = 1 occurrences in three cycles
reg [1:0] w_count;
reg [1:0] w_count_next;

// Flag to indicate if we've counted two w = 1s in the last three cycles
reg z_flag;
reg z_flag_next;

// Default values
initial state = 2'b00; // Start in State A
initial w_count = 2'b00;
initial z_flag = 1'b0;

always @(*) begin
    state_next = state;
    w_count_next = w_count;
    z_flag_next = z_flag;

    case(state)
        2'b00: // State A
            if(s) begin
                state_next = 2'b01; // Move to State B
                w_count_next = 2'b00; // Reset w_count
                z_flag_next = 1'b0; // Reset z_flag
            end
        2'b01: // First cycle in State B
            if(w) w_count_next = 2'b01;
            state_next = 2'b10;
        2'b10: // Second cycle in State B
            if(w) w_count_next = w_count + 1'b1;
            state_next = 2'b11;
        2'b11: // Third cycle in State B
            if(w) w_count_next = w_count + 1'b1;
            state_next = 2'b01; // Reset to first cycle of State B
            if(w_count == 2'b10 || w_count == 2'b01) z_flag_next = 1'b1; // Set z_flag if w_count is 2
            else z_flag_next = 1'b0;
    endcase

    if(reset) begin // Synchronous reset
        state_next = 2'b00;
        w_count_next = 2'b00;
        z_flag_next = 1'b0;
    end
end

always @(posedge clk) begin
    state <= state_next;
    w_count <= w_count_next;
    z_flag <= z_flag_next;
end

assign z = z_flag;

endmodule