module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Module 1: Reset and Initialization
reg initialized;
always @(posedge clk) begin
    if (!resetn) begin
        initialized <= 0;
        f <= 0;
        g <= 0;
    end else if (!initialized) begin
        initialized <= 1;
        f <= 1; // Set f to 1 for one clock cycle after reset
    end
end

// Module 2: Sequence Detector for x
reg [2:0] x_sequence;
always @(posedge clk) begin
    if (!resetn) begin
        x_sequence <= 0;
    end else if (initialized) begin
        case (x_sequence)
            0: if (x) x_sequence <= 1;
            1: if (!x) x_sequence <= 2; else x_sequence <= 0;
            2: if (x) x_sequence <= 3; else x_sequence <= 0;
            3: x_sequence <= 3; // Sequence detected, stay here
        endcase
    end
end

// Module 3: Y Monitor and Output Controller
reg [1:0] y_timer;
reg g_set;
always @(posedge clk) begin
    if (!resetn) begin
        y_timer <= 0;
        g_set <= 0;
        g <= 0;
    end else if (x_sequence == 3 && !g_set) begin // Sequence detected, set g and start monitoring y
        g_set <= 1;
        g <= 1;
        y_timer <= 1;
    end else if (g_set) begin
        if (y) begin // Y is 1 within the time frame, keep g = 1 permanently
            y_timer <= 0;
        end else begin
            y_timer <= y_timer + 1;
            if (y_timer > 2) begin // Y did not become 1 within two cycles, set g = 0 permanently
                g <= 0;
            end
        end
    end
end

endmodule