module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Enumerate states
    enum logic [2:0] {
        A = 3'b000,
        TEMP = 3'b001,
        MONITOR_X = 3'b010,
        MONITOR_Y = 3'b011,
        G_HIGH = 3'b100,
        G_LOW = 3'b101
    } state, next_state;

    // Internal signals for monitoring x sequence
    reg [1:0] x_seq_counter;
    reg [1:0] y_wait_counter;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_seq_counter <= 0;
            y_wait_counter <= 0;
        end else begin
            state <= next_state;
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                end
                TEMP: begin
                    f <= 1;
                    g <= 0;
                end
                MONITOR_X: begin
                    f <= 0;
                    g <= 0;
                end
                MONITOR_Y: begin
                    f <= 0;
                    g <= 1;
                end
                G_HIGH: begin
                    f <= 0;
                    g <= 1;
                end
                G_LOW: begin
                    f <= 0;
                    g <= 0;
                end
            endcase
            case (state)
                A: begin
                    // Transition from A to TEMP when reset is de-asserted
                    if (resetn) next_state <= TEMP;
                    else next_state <= A;
                end
                TEMP: begin
                    // Transition from TEMP to MONITOR_X after one clock cycle
                    next_state <= MONITOR_X;
                end
                MONITOR_X: begin
                    // Monitor x for sequence 1, 0, 1
                    if (x_seq_counter == 2'b00 && x) x_seq_counter <= 2'b01;
                    else if (x_seq_counter == 2'b01 && !x) x_seq_counter <= 2'b10;
                    else if (x_seq_counter == 2'b10 && x) x_seq_counter <= 2'b11;
                    else x_seq_counter <= 2'b00;
                    if (x_seq_counter == 2'b11) next_state <= MONITOR_Y;
                    else next_state <= MONITOR_X;
                end
                MONITOR_Y: begin
                    // Monitor y for 1 within two clock cycles
                    if (y) next_state <= G_HIGH;
                    else if (y_wait_counter < 2) begin
                        y_wait_counter <= y_wait_counter + 1;
                        next_state <= MONITOR_Y;
                    end else next_state <= G_LOW;
                end
                G_HIGH: begin
                    // Maintain g = 1 permanently
                    next_state <= G_HIGH;
                end
                G_LOW: begin
                    // Maintain g = 0 permanently
                    next_state <= G_LOW;
                end
            endcase
        end
    end

endmodule