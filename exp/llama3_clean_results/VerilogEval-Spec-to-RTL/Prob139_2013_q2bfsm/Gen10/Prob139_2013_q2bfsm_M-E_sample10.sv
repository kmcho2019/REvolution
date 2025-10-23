module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // FSM state (0: initialization, 1: sequence detection, 2: y monitoring, 3: final state)
reg [1:0] seq_counter; // Counter for sequence detection
reg y_timer; // Timer for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0;
        seq_counter <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Initialization state
                f <= 1;
                state <= 1;
            end
            1: begin // Sequence detection state
                if (x && seq_counter == 0) begin
                    seq_counter <= 1;
                end else if (!x && seq_counter == 1) begin
                    seq_counter <= 2;
                end else if (x && seq_counter == 2) begin
                    state <= 2; // Transition to y monitoring state
                    seq_counter <= 0;
                end else begin
                    seq_counter <= 0;
                end
                f <= 0; // Reset f after one cycle
            end
            2: begin // Y monitoring state
                if (y) begin
                    state <= 3; // Transition to final state
                    g <= 1; // Set g to 1 permanently
                end else if (y_timer == 1) begin
                    state <= 3; // Transition to final state
                    g <= 0; // Set g to 0 permanently
                end else begin
                    y_timer <= y_timer + 1;
                end
            end
            3: begin // Final state
                // No action, g is already set
            end
        endcase
    end
end