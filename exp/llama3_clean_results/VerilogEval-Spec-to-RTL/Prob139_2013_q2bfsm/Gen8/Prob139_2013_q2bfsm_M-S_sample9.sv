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
        if (x_sequence == 0 && x) begin
            x_sequence <= 1;
        end else if (x_sequence == 1 && !x) begin
            x_sequence <= 2;
        end else if (x_sequence == 2 && x) begin
            x_sequence <= 0;
            detected <= 1; // Sequence detected
            f <= 1; // Set f for one clock cycle
        end else if (x_sequence != 0) begin
            x_sequence <= 0;
        end

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

        if (f) begin
            f <= 0; // Reset f after one cycle
        end
    end
end