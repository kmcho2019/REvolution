module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] x_sequence; // Counter for x sequence detection
reg [1:0] y_timer; // Timer for y monitoring
reg detected; // Flag to indicate sequence detection

always @(posedge clk) begin
    if (!resetn) begin
        x_sequence <= 0;
        y_timer <= 0;
        detected <= 0;
        f <= 0;
        g <= 0;
    end else begin
        // X sequence detection
        case (x_sequence)
            0: if (x) x_sequence <= 1;
            1: if (!x) x_sequence <= 2;
            2: if (x) x_sequence <= 3; // Detect sequence
            default: x_sequence <= 0; // Reset sequence
        endcase

        // Set detected flag
        if (x_sequence == 3) begin
            detected <= 1;
            x_sequence <= 0; // Reset sequence
            f <= 1; // Set f for one clock cycle
        end

        // Y timer and g output
        if (detected) begin
            if (y_timer == 0) begin
                y_timer <= 1;
                if (y) begin
                    g <= 1; // Set g to 1 permanently
                end
            end else if (y_timer == 1) begin
                y_timer <= 2;
                if (y) begin
                    g <= 1; // Set g to 1 permanently
                end else begin
                    g <= 0; // Set g to 0 permanently
                end
            end
        end

        // Reset f after one cycle
        if (f) begin
            f <= 0;
        end
    end
end