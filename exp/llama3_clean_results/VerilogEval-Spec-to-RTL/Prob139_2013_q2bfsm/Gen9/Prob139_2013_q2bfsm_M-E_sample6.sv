module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // Top-level state (0: initialization, 1: monitoring, 2: detected sequence)
reg [2:0] seq_counter; // Counter for sequence detection
reg [1:0] timer; // Timer for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0;
        seq_counter <= 0;
        timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Initialization state
                f <= 1;
                state <= 1;
            end
            1: begin // Monitoring state
                if (x) begin
                    if (seq_counter == 0) begin
                        seq_counter <= 1;
                    end else if (seq_counter == 1 &&!x) begin
                        seq_counter <= 2;
                    end else if (seq_counter == 2 && x) begin
                        state <= 2; // Transition to detected sequence state
                        seq_counter <= 0;
                    end else begin
                        seq_counter <= 0;
                    end
                end
                f <= 0; // Reset f after one cycle
            end
            2: begin // Detected sequence state
                if (timer == 0) begin
                    timer <= 1;
                    if (y) begin
                        g <= 1; // Set g to 1 permanently
                    end
                end else if (timer == 1) begin
                    timer <= 2;
                    if (y) begin
                        g <= 1; // Set g to 1 permanently
                    end else begin
                        g <= 0; // Set g to 0 permanently
                    end
                end
            end
        endcase
    end
end