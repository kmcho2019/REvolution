module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

reg [2:0] state; // 3-bit state register

// State definitions
localparam A = 3'b000; // Initial state
localparam B = 3'b001; // State to set f to 1
localparam C = 3'b010; // State to monitor x input
localparam D = 3'b011; // State to set g to 1 and monitor y
localparam E = 3'b100; // State to keep g = 1 permanently
localparam F = 3'b101; // State to keep g = 0 permanently

reg [1:0] x_count; // Counter for x input sequence
reg [1:0] y_count; // Counter for y input

always @ (posedge clk) begin
    if (~resetn) begin // Reset condition
        state <= A;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
            end
            B: begin
                state <= C;
                f <= 1;
                g <= 0;
                x_count <= 0;
            end
            C: begin
                if (x == 1 && x_count == 0) begin
                    x_count <= x_count + 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= x_count + 1;
                end else if (x == 1 && x_count == 2) begin
                    state <= D;
                    x_count <= 0;
                end else begin
                    x_count <= 0;
                end
                f <= 0;
                g <= 0;
            end
            D: begin
                state <= D;
                f <= 0;
                g <= 1;
                if (y == 1 || y_count == 2) begin
                    if (y == 1) begin
                        state <= E;
                    end else begin
                        state <= F;
                    end
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                end
            end
            E: begin
                state <= E;
                f <= 0;
                g <= 1;
            end
            F: begin
                state <= F;
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule