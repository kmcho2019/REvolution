module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_seq; // 0: initial, 1: seen 1, 2: seen 10
reg [1:0] y_count; // Count cycles since f was set
reg set_f; // Flag to set f for one cycle
reg wait_y; // Flag indicating we're waiting for y

always @ (posedge clk) begin
    if (!resetn) begin
        // Reset all signals and states
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
        set_f <= 1'b0;
        wait_y <= 1'b0;
    end else begin
        // Sequence detection for x
        case (x_seq)
            0: if (x) x_seq <= 1; // Seen first 1
            1: if (!x) x_seq <= 2; else x_seq <= 1; // Seen 10
            2: if (x) begin
                x_seq <= 0; // Restart sequence detection
                set_f <= 1'b1; // Set f for next cycle
            end else x_seq <= 0; // Reset sequence if x is not 1 after 10
        endcase

        // Set f for one cycle after sequence detection
        if (set_f) begin
            f <= 1;
            set_f <= 1'b0;
            wait_y <= 1'b1;
            y_count <= 0; // Reset y count
        end else begin
            f <= 0;
        end

        // Wait for y after f has been set
        if (wait_y) begin
            if (y) begin
                g <= 1; // Set g permanently if y is seen
                wait_y <= 1'b0; // Exit wait_y state
            end else if (y_count < 2) begin
                y_count <= y_count + 1; // Increment count
            end else begin
                g <= 0; // Set g to 0 if y not seen within 2 cycles
                wait_y <= 1'b0; // Exit wait_y state
            end
        end
    end
end

endmodule