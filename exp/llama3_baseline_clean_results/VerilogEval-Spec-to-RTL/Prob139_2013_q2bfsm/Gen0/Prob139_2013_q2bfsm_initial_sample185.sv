module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;  // Define states
localparam A = 3'b000;  // Reset state
localparam B = 3'b001;  // Set output f to 1
localparam C = 3'b010;  // Monitor x input
localparam D = 3'b011;  // Set output g to 1 and monitor y input
localparam E = 3'b100;  // Maintain g = 1 permanently
localparam F = 3'b101;  // Set g = 0 permanently

reg [1:0] x_counter;  // Counter for monitoring x input
reg [1:0] y_counter;  // Counter for monitoring y input
reg [2:0] x_history;  // History of x input

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
        x_history <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                    f <= 1;
                end
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                x_history <= {x, x_history[1:0]};
                if (x_history == 3'b101) begin
                    state <= D;
                    g <= 1;
                    x_counter <= 0;
                    y_counter <= 0;
                end
            end
            D: begin
                y_counter <= y_counter + 1;
                if (y) begin
                    state <= E;
                end else if (y_counter == 2) begin
                    state <= F;
                end
            end
            E: begin
                g <= 1;
            end
            F: begin
                g <= 0;
            end
        endcase
    end
end

endmodule