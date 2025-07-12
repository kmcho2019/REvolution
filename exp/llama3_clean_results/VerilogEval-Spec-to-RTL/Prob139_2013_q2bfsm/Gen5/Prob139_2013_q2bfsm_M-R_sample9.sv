module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] x_count; // Count the sequence in x
reg y_detected; // Flag to indicate y has been detected
reg [1:0] y_timer; // Timer for y detection

always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_detected <= 0;
        y_timer <= 0;
    end else begin
        if (x_count == 0) begin // Waiting for the sequence in x
            if (x) begin
                x_count <= 1;
                f <= 0;
            end else begin
                f <= 0;
            end
        end else if (x_count == 1) begin // First 1 detected
            if (!x) begin
                x_count <= 2;
                f <= 0;
            end else begin
                x_count <= 1;
            end
        end else if (x_count == 2) begin // Second 0 detected
            if (x) begin
                x_count <= 3;
                f <= 1; // Set f to 1 for one clock cycle
            end else begin
                x_count <= 1;
            end
        end else if (x_count == 3) begin // Sequence in x detected
            f <= 0;
            if (!y_detected) begin // Not detected y yet
                if (y) begin
                    y_detected <= 1; // y detected
                    g <= 1;
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer > 1) begin
                        g <= 0; // y not detected within two cycles
                        y_timer <= 0;
                    end else begin
                        g <= 0;
                    end
                end
            end else begin // y already detected
                g <= 1;
            end
        end
    end
end

endmodule