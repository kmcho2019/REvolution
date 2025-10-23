module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;          // Previous sampled input
    reg rise_reg;     // Registered rise pulse
    reg down_reg;     // Registered down pulse

    // Register previous input and edge detect logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d <= 1'b0;
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end else begin
            a_d <= a;

            // Default clear rise and down pulses
            rise_reg <= 1'b0;
            down_reg <= 1'b0;

            // Detect edges based on previous sampled input and current input
            if (~a_d & a)
                rise_reg <= 1'b1;   // Rising edge detected
            else if (a_d & ~a)
                down_reg <= 1'b1;   // Falling edge detected
        end
    end

    // Assign outputs from registered signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_reg;
            down <= down_reg;
        end
    end

endmodule